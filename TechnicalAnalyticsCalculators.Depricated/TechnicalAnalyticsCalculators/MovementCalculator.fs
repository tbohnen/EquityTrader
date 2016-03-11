namespace TechnicalAnalysisIndicators
module MovementCalculator =
  open TechnicalAnalyticsCalculators.MongoRepository
  open System

  let endOfDay (date:DateTime) = new System.DateTime(date.Year,date.Month, date.Day, 23,59,59)
  let getChange (oldestPrice:decimal) (newestPrice:decimal) =
    if newestPrice <> 0m && oldestPrice <> 0m then System.Math.Round((((newestPrice / oldestPrice) - 1m) * 100m),2) else -1m

  let daysMovement (date:System.DateTime) (share:string) (noDays:int) =
    let oldestDate = endOfDay (date.AddDays(float -noDays))
    let newestDate = endOfDay date

    let oldestShares = (GetTopNEquitiesOnOrBefore oldestDate share 1)
    let newestShares = (GetTopNEquitiesOnOrBefore newestDate share 1)


    if oldestShares.Length > 0 && newestShares.Length > 0 then
      let oldestPrice = oldestShares.Item(0).ClosePrice
      let newestPrice = newestShares.Item(0).ClosePrice
      let change = getChange (oldestPrice) (newestPrice)
      change
    else -1m
