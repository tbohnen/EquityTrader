defmodule CompanyImport do
  import Enum

  def import_company_types(path) do
    File.stream!(path) |>
      map(fn l -> String.rstrip(l) |>
          String.split(",") end) |>
      each(fn l -> zip([:Type, :ShortName], l) |> into(%{}) |> update_company end)
  end

  def update_company(company) do
    existing_share = MongoRepository.find(%{ShortName: company."ShortName"}, "Company") |> at(0)
    if !is_nil(existing_share) do
      existing_share = Dict.put(existing_share, :Type, company[:Type])
      MongoRepository.update(%{ShareIndex: existing_share[:ShareIndex]}, existing_share, "Company", true, false)
    else
      Dict.put(company, :ShareIndex, company[:ShortName])
      MongoRepository.insert(company, "Company")
    end

  end


end
