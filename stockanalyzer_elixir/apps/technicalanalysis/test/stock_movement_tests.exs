defmodule StockMovementTests do
  use ExUnit.Case
  use Timex
  import StockAnalyzerTestHelper

  setup do
    MongoRepository.drop_collection("Equity")

    create_new_equity "SHF", "20150512", "50"
    create_new_equity "SHF", "20150513", "100"
  end

  test "Generate One Day Movement For Given Date" do
    movement = MovementCalculator.movement_for("SHF",Date.from({2015, 5, 13}),1)
    assert movement == 100
  end

end

# let testDate = new DateTime(2015,5,11)

# [<Test>]
# let ``Generate Technical Analysis for SHF for given date`` () =
#   let testIndicator = TechnicalAnalysisGenerator.generate testDate "SHF"

#   testIndicator.DailyMovement |> should equal 1.12m
#   testIndicator.TwoWkGrowth |> should equal -1.92m
#   testIndicator.FourWkGrowth |> should equal 1.28m
#   testIndicator.SixMonthGrowth |> should equal 38.46m
#   testIndicator.OneYearGrowth |> should equal 43.34m
#   testIndicator.ThreeYearGrowth |> should equal 175.99m
#   testIndicator.FiveYearGrowth |> should equal 294.87m

# [<Test>]
# let ``Test that DBXJP has correct daily movement``() =
#   let date = new DateTime(2015,1,22)
#   let testIndicator = TechnicalAnalysisGenerator.generate date "DBXJP"

#     testIndicator.DailyMovement |> should equal -0.6m
