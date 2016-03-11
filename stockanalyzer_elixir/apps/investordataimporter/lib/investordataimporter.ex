defmodule InvestorDataImporter do
  import MongoHelper
  use Timex
  import Enum
  require Logger

  def import_all_daily_files_from_folder(path) do
    {:ok, files } = File.ls path

    files |> each fn f ->
      filename = path <> "/" <> f

      import_daily_file(filename)


      File.cp(filename, path <> "processed/" <> f)
      File.rm(filename)

    end

  end

  def import_daily_file(filename) do
    extract_memory(filename) |>

      each fn f ->
      {file, lines } = f

      cond do
        String.ends_with?(to_string(file), "EDH") ->
          IO.puts "Implement corrections"
        String.ends_with?(to_string(file), "EDD") -> process_edd(lines)
       true -> IO.puts "unsupported file #{to_string(file)}"
      end
    end

  end

  def process_edd(lines) do
    String.split(lines, "\r\n") |> map fn line -> if line != "", do: import_daily_line(line,"") end
  end

  #this would be a good idea to use metaprogramming (maybe?) to iterate and set the group names
  def import_daily_line(line, last_group) do

    {:ok, equity} = String.split(line) |> line_to_equity

    set_previous_to_not_latest(equity)

    MongoRepository.insert(equity, "Equity")
  end


  defp set_previous_to_not_latest(equity) do
    #for some reason the bulk updating is not working, figure out why
    MongoRepository.find(%{ShareIndex: equity."ShareIndex", DateOfPrice: equity."DateOfPrice" , Latest: true},"Equity") |>
      Enum.each fn e ->
        e = %{e | :Latest => false}
        MongoRepository.update(%{_id: e."_id"}, e, "Equity", false, false)
    end

  end

  def import_company_names(path) do
    data_stream = File.stream!(path)
    each(data_stream,
      fn line ->
        transformed_line = String.strip(line, ?\n) |>
          String.split(",",trim: true) |>
          Enum.map(fn l -> String.rstrip(l) end)

        mapped = Enum.zip([:ShareIndex, :ShortName, :CompanyName, :Sector, :Industry], transformed_line) |>
          Enum.into(%{})

        #this is a nasty hack because the short name is very important in mapping and differs between InvestorData and JSE data

        existing_share = MongoRepository.find(%{ShareIndex: mapped."ShareIndex"}, "Company") |> Enum.at(0)

        if !is_nil(existing_share), do: mapped = %{mapped | :ShortName => existing_share[:ShortName]}

        MongoRepository.update(%{ShareIndex: mapped[:ShareIndex]}, mapped, "Company", true, false)

      end)
  end

  def import_historical_to_db(path) do
    extract(path)
    File.stream!('SQL.TXT') |>
    Enum.map(fn line ->
      {status, equity} = String.split(line) |> line_to_equity

      if status == :ok && !equity_already_imported?(equity), do: equity, else: %{} end) |>
      take_while(fn i -> i != %{} end) |>
      MongoRepository.insert("Equity")
  end

  def line_to_equity(line) do

    mapped_line = Enum.zip([:name, :date, :close, :high, :low, :vol, :openinterest, :x, :y], line) |>
      Enum.into(%{})

    {vol,_} = Float.parse(mapped_line.vol);
    {low,_} = Float.parse(mapped_line.low);
    {high,_} = Float.parse(mapped_line.high);
    {close,_} = Float.parse(mapped_line.close);

      date_retrieved = date_to_bson(Date.now)

      case string_to_bson_date(mapped_line.date) do
        {:error, msg} -> {:error, msg}
        { :ok, date_of_price } ->
          {:ok, %{
              Latest: true,
              DateRetrieved: date_retrieved,
              DateOfPrice: date_of_price,
              Volume: vol,
              LowPrice: low,
              HighPrice: high,
              ClosePrice: close,
              ShareIndex: share_code(mapped_line.name),
              }
          }
      end

  end

  def equity_already_imported?(equity) do
    { start_date, end_date } = date_of_price_query(bson_date_to_datepart equity[:DateOfPrice])
    mongo_and_query([%{ShareIndex: equity[:ShareIndex]}, start_date, end_date ],"Equity") |> empty? != true
 end

  def insert_if_not_exists(equity) do
    { start_date, end_date } = date_of_price_query(bson_date_to_datepart equity[:DateOfPrice])

    exists = mongo_and_query([%{ShareIndex: equity[:ShareIndex]}, start_date, end_date ],"Equity") |> at(0)

    if !exists, do: MongoRepository.insert(equity, "Equity")

  end

  def share_code(short_name) do

    companies = MongoRepository.find(%{ShortName: short_name}, "Company")
    company = companies |> Enum.at(0)

    if is_nil(company), do: short_name, else: company."ShareIndex"

  end

  def extract(path) do
    {:ok, files} = :zip.extract(to_char_list path)
    files
  end

  def extract_memory(filename) do
    {:ok, file} = :zip.extract(to_char_list(filename), [:memory])
    file
  end


end
