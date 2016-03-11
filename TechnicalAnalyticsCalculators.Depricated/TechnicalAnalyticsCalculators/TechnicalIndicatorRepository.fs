namespace TechnicalAnalysis
open System

module TechnicalIndicatorRepository =
    open MongoDB.Bson
    open MongoDB.Driver
    open MongoDB.Driver.Builders
    open MongoDB.FSharp
    open System.Linq
    open System.Configuration

    Serializers.Register()

    type TechnicalIndicator = { _id: BsonObjectId; ShareIndex: string; Date: DateTime; Official: bool;
                                DailyMovement: decimal;
                                TwoWkGrowth : decimal;
                                FourWkGrowth  : decimal;
                                SixMonthGrowth  : decimal;
                                OneYearGrowth : decimal;
                                ThreeYearGrowth : decimal;
                                FiveYearGrowth : decimal;
                                }
 
    let appSettingsReader = new System.Configuration.AppSettingsReader()
    let connectionString = appSettingsReader.GetValue("MongoConnectionString", typedefof<string>)
    let client = new MongoClient(string connectionString)
    let server = client.GetServer();

    let dbName = appSettingsReader.GetValue("MongoDb", typeof<string>).ToString()
    let db = server.GetDatabase(dbName)
    let technicalIndicatorCollection = db.GetCollection<TechnicalIndicator> "TechnicalIndicator"

    let update technicalIndicator =
      let writeResult = technicalIndicatorCollection.Remove(Query.And(
                                                                Query.EQ("ShareIndex",BsonValue.Create(technicalIndicator.ShareIndex)),
                                                                Query.EQ("Date", BsonValue.Create(technicalIndicator.Date))))
      technicalIndicatorCollection.Insert(technicalIndicator)
