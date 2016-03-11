namespace TechnicalAnalysis

module TechnicalAnalysisGenerator =
  open TechnicalAnalysis.TechnicalIndicatorRepository
  open TechnicalAnalysisIndicators.MovementCalculator
  open MongoDB.Bson
  open TechnicalAnalyticsCalculators.MongoRepository

  let generate date shareIndex =
    let id = BsonObjectId(ObjectId.GenerateNewId())
    let dailyMovement = daysMovement date shareIndex 1
    let twoWkGrowth = daysMovement date shareIndex 14
    let fourWkGrowth = daysMovement date shareIndex 28
    let sixMonthGrowth = daysMovement date shareIndex 180
    let oneYearGrowth = daysMovement date shareIndex 365
    let threeYearGrowth = daysMovement date shareIndex 1095
    let fiveYearGrowth = daysMovement date shareIndex 1825

    let newIndicator = {
      _id = id;
      ShareIndex = shareIndex;
      Date = date;
      DailyMovement = dailyMovement;
      TwoWkGrowth = twoWkGrowth;
      FourWkGrowth  = fourWkGrowth;
      SixMonthGrowth  = sixMonthGrowth;
      OneYearGrowth = oneYearGrowth;
      ThreeYearGrowth = threeYearGrowth;
      FiveYearGrowth = fiveYearGrowth;
      Official = true;
      }

    update newIndicator

    newIndicator

  let generateAllForDate date =
    let shares = GetAllLatestForDate date
    printfn "No of Shares: %i  for: %s" (shares.Length) (date.ToString())
    for share in shares do
      printfn "generating for %s" share.ShareIndex
      generate date share.ShareIndex; 0
      //with
        //| _ -> printfn "%s" ("could not load" + share.ShareIndex); 0

  let generateAllAfterDate date =
    let mutable currentDate = date
    while currentDate <= System.DateTime.Now do
      printfn "Generating: %s" (currentDate.ToString())
      generateAllForDate currentDate
      currentDate <- currentDate.AddDays(1.0)
