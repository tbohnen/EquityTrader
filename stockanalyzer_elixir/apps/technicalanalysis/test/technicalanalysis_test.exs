defmodule TechnicalanalysisTest do
  use ExUnit.Case
  use Timex
  import MongoHelper
  import StockAnalyzerTestHelper
  import Enum

  setup do
    clear_collection("TechnicalIndicator")
    clear_collection("Equity")
  end

  test "Generate all shares for given date till current date" do
    create_new_equity "SHF", "20150504", "100"
    create_new_equity "SHF", "20150501", "50"

    create_new_equity "APN", "20150504", "50"
    create_new_equity "APN", "20150501", "100"

    start_date = Date.from({2015,5,1})
    end_date = Date.from({2015,5,4})

    TechnicalAnalysis.generate_all_between_days(start_date, end_date)
    indicators = MongoRepository.find(%{}, "TechnicalIndicator")

    assert indicators |> count == 4

    latest_apn = Enum.sort(indicators, &(&1[:Date] > &2[:Date])) |>
      Enum.find(&(&1[:ShareIndex] == "APN"))

    assert latest_apn[:DailyMovement] == -50

  end

  test "Generate all shares found on given date" do
    create_new_equity "SHF", "20150504", "100"
    create_new_equity "SHF", "20150501", "50"

    create_new_equity "APN", "20150504", "50"
    create_new_equity "APN", "20150501", "100"

    results = TechnicalAnalysis.generate_all_for_day(Date.from({2015,5,4}))

    assert results |> count == 2

    {:ok, shf} = results |> find fn e -> elem(e, 1)[:ShareIndex] == "SHF" end
    {:ok, apn} = results |> find fn e -> elem(e, 1)[:ShareIndex] == "APN" end

    assert shf[:DailyMovement] == 100
    assert apn[:DailyMovement] == -50
  end

  test "Returns -1 if a movement could not be found" do
    create_new_equity "SHF", "20150504", "100"

    {:ok, technical} = TechnicalAnalysis.generate_for_day("SHF", Date.from({2015,5,4}))

    assert technical[:DailyMovement] == -1
  end

  test "Set's all previous records to false for a given date and share if it has already ran and is requested again" do

    start_time = Date.from({{2015,5,4}, {0, 0, 0}})
    end_time = Date.from({{2015,5,4}, {23, 59, 59}})

    share = "SHF"
    create_new_equity share, "20150504", "100"

    TechnicalAnalysis.generate_for_day(share, Date.from({2015,5,4}))
    TechnicalAnalysis.generate_for_day(share, Date.from({2015,5,4}))

    count = MongoRepository.find(
      %{
        '$and':
        [
          %{ShareIndex: share},
          %{Date: %{'$gte': start_time |> date_to_bson }},
          %{Date: %{'$lte': end_time |> date_to_bson }},
          %{Official: true}
        ]
        },"TechnicalIndicator") |> Enum.count

    assert count == 1

  end

  test "Get's closest date before or on date requested to cater for business and public holidays" do
    create_new_equity "SHF", "20150504", "100"
    create_new_equity "SHF", "20150501", "50"
    create_new_equity "SHF", "20150430", "100"
    create_new_equity "SHF", "20150505", "100"
    create_new_equity "SHF", "20150429", "100"

    {:ok, technical} = TechnicalAnalysis.generate_for_day("SHF", Date.from({2015,5,4}))

    assert technical[:DailyMovement] == 100

  end

  test "Generate all movement for SHF and Day 2015 5 13" do
    create_new_equity "SHF", "20150513", "100"
    create_new_equity "SHF", "20150512", "50"
    create_new_equity "SHF", "20150429", "200"
    create_new_equity "SHF", "20150415", "10"
    create_new_equity "SHF", "20141114", "80"
    create_new_equity "SHF", "20140513", "20"
    create_new_equity "SHF", "20120513", "70"
    create_new_equity "SHF", "20100514", "50"

    date = Date.from({2015,5,13})
    share = "SHF"

    {:ok, technical} = TechnicalAnalysis.generate_for_day(share, date)

    assert technical[:DailyMovement] == 100
    assert technical[:TwoWkGrowth] == -50
    assert technical[:FourWkGrowth] == 900
    assert technical[:SixMonthGrowth] == 25
    assert technical[:OneYearGrowth] == 400
    assert technical[:ThreeYearGrowth] == 42.86
    assert technical[:FiveYearGrowth] == 100
  end

end
