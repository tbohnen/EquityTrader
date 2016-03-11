defmodule InvestordataimporterTest do
  use ExUnit.Case
  use Timex
  require Logger
  import MongoHelper
  import Enum

   setup do
     MongoRepository.drop_collection("Equity")
     MongoRepository.drop_collection("Company")

     MongoRepository.insert(%{ShortName: "", ShareIndex: ""}, "Company")
   end


   test "Does Import Calgro" do

     InvestorDataImporter.import_company_names('test/data/InvestorDataCompanyNames.TXT')
     InvestorDataImporter.import_daily_file('../../../InvestorData/20150803.zip')
     { start_date, end_date } = date_of_price_query({2015,08,03})

     calgro = MongoRepository.find(%{'$and': [ start_date,
                                                           end_date,
                                                           %{ShareIndex: "CGR"}
                                                         ]},"Equity")
     assert !is_nil(calgro)
   end

   test "Import All Daily Files in folder and move to archived" do
     File.cp("test/data/dailyfilesstaging/20150803.zip", "test/data/dailyfiles/20150803.zip")
     File.cp("test/data/dailyfilesstaging/20150804.zip", "test/data/dailyfiles/20150804.zip")
     File.rm("test/data/dailyfilesprocessed/20150803.zip")
     File.rm("test/data/dailyfilesprocessed/20150804.zip")

     {:ok, ["20150803.zip", "20150804.zip"]} = File.ls("test/data/dailyfiles")

     InvestorDataImporter.import_all_daily_files_from_folder("test/data/dailyfiles")

     {:ok, []} = File.ls("test/data/dailyfiles")
     {:ok, ["20150803.zip", "20150804.zip"]} = File.ls("test/data/dailyfilesprocessed")

     number_of_equities = MongoRepository.find(%{},"Equity") |> count

     assert number_of_equities == 8996
   end

   test "Import Daily file" do
     InvestorDataImporter.import_daily_file('test/data/20150803.zip')
     { start_date, end_date } = date_of_price_query({2015,08,03})

     number_of_equities = MongoRepository.find(%{'$and': [ start_date,
                                              end_date
                                            ]},"Equity") |> count
     number_of_equities_excluding_headings = 4490

     assert (number_of_equities) == number_of_equities_excluding_headings

     astral = (MongoRepository.find(%{'$and': [ %{ShareIndex: "ASTRAL"}, start_date, end_date ]},"Equity") |> at(0))
     assert astral[:ClosePrice] == 17200
     assert astral[:HighPrice] == 17490
     assert astral[:LowPrice] == 16680
     assert astral[:Volume] == 162981
     assert bson_date_to_string(astral[:DateOfPrice]) == "2015-8-3T0:0:0"
   end

   test "Do not import company if exists" do
     InvestorDataImporter.import_company_names('test/data/InvestorDataCompanyNames.TXT')
     assert MongoRepository.find(%{ShareIndex: %{'$ne': ""}}, "Company") |> count == 2457
   end

   test "Import companies if not existing or update" do
     InvestorDataImporter.import_company_names('test/data/InvestorDataCompanyNames.txt')
     InvestorDataImporter.import_company_names('test/data/NewCompanies.txt')

     assert MongoRepository.find(%{ShortName: "ABIL", ShareIndex: "ABL"}, "Company") |> count > 0
     assert MongoRepository.find(%{ShortName: "WOOLIES", ShareIndex: "WHL"}, "Company") |> count > 0
     assert MongoRepository.find(%{ShortName: "CALGRO-M3", ShareIndex: "CGR"}, "Company") |> count > 0

     assert MongoRepository.find(%{ShareIndex: %{'$ne': ""}}, "Company") |> count == 2472
   end

  test "Extract Historical Data to db" do
    InvestorDataImporter.import_company_names('test/data/InvestorDataCompanyNames.txt')
    InvestorDataImporter.import_historical_to_db('test/data/historical.zip')

    assert MongoRepository.find(%{ShareIndex: "1TM"},"Equity") |> Enum.count == 4
    assert MongoRepository.find(%{ShareIndex: "ABL"},"Equity") |> Enum.count == 69

    share = share_on_date("1TM",{2010,01,04})
    assert share[:ClosePrice] == 105
    assert share[:HighPrice] == 105
    assert share[:LowPrice] == 105
    assert share[:Volume] == 2905
    assert bson_date_to_string(share[:DateOfPrice]) == "2010-1-4T0:0:0"
    assert !is_nil(share[:DateRetrieved])
    assert share[:Latest]

  end

  test "Does not throw error when line cannot be converted" do
    line = String.split("BATF-U5 19000000 0 0 0 0 0 0 0 0")
    line |> InvestorDataImporter.line_to_equity
  end

  test "Can correctly import line" do
    line = String.split("BASREAD 20150828 435 435 400 14974 400 0 0 0")
    {:ok, equity} = line |> InvestorDataImporter.line_to_equity
    assert equity."ClosePrice" == 435
    assert bson_date_to_string(equity."DateOfPrice") == "2015-8-28T0:0:0"
    assert equity."HighPrice" == 435
    assert equity."LowPrice" == 400
    assert equity."ShareIndex" == "BASREAD"
    assert equity."Volume" == 14974
  end

  test "Does not import historical item if already exists for that date" do
    InvestorDataImporter.import_historical_to_db('test/data/historical.zip')
    InvestorDataImporter.import_historical_to_db('test/data/historical.zip')
    assert MongoRepository.find(%{},"Equity") |> Enum.count == 73

  end

  def share_on_date(share, date) do

    { start_date, end_date } = date_of_price_query(date)

    MongoRepository.find(
                                %{
                                    '$and':
                                    [
                                    %{ShareIndex: share},
                                    %{Latest: true},
                                    start_date,
                                    end_date
                                    ]
                                },"Equity") |> Enum.at(0)
  end

  test "convert line will continue on error" do
    #TOD
  end


end
