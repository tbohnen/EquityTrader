namespace TechnicalAnalysis

module TechnicalAnalysisGeneratorTests =
  open NUnit.Framework
  open FsUnit
  open System
  open TechnicalAnalysisGenerator
  open TechnicalAnalysis.TechnicalIndicatorRepository

  let testDate = new DateTime(2015,5,11)

  [<Test>]
  let ``Generate Technical Analysis for SHF for given date`` () =
    let testIndicator = TechnicalAnalysisGenerator.generate testDate "SHF"

    testIndicator.DailyMovement |> should equal 1.12m
    testIndicator.TwoWkGrowth |> should equal -1.92m
    testIndicator.FourWkGrowth |> should equal 1.28m
    testIndicator.SixMonthGrowth |> should equal 38.46m
    testIndicator.OneYearGrowth |> should equal 43.34m
    testIndicator.ThreeYearGrowth |> should equal 175.99m
    testIndicator.FiveYearGrowth |> should equal 294.87m

  [<Test>]
  let ``Test that DBXJP has correct daily movement``() =
    let date = new DateTime(2015,1,22)
    let testIndicator = TechnicalAnalysisGenerator.generate date "DBXJP"

    testIndicator.DailyMovement |> should equal -0.6m
