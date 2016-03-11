namespace TechnicalAnalyticsCalculators

module SMA =
    let calcSMA = 1

module Calculators =
   let CalcMacd shareIndex =
        let closePrices = MongoRepository.GetClosePrices (shareIndex, new System.DateTime(2014,01,01))
        printfn "%A" closePrices
        1
