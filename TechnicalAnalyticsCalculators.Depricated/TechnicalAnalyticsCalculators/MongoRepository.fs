namespace TechnicalAnalyticsCalculators
open System

module MongoRepository =
    open MongoDB.Bson
    open MongoDB.Driver
    open MongoDB.Driver.Builders
    open MongoDB.FSharp
    open System.Linq
    open System.Configuration

    //Serializers.Register()

    type Macd = { Id : BsonObjectId; ShareIndex : string; MacdLine : double; Histogram : double; SignalLine : double; }

    type Equity = { _id : BsonObjectId;
                    ShareIndex : string;
                    OpenPrice : Decimal;
                    ClosePrice : decimal;
                    DividendYield : decimal;
                    MarketCap : string;
                    PeRatio : string;
                    DateRetrieved : DateTime;
                    DateOfPrice : DateTime;
                    Volume : string;
                    Sector : string;
                    Eps : string;
                    ShareName : string;
                    Latest : bool;
                    HighPrice: Decimal;
                    LowPrice : Decimal
                    }

    let mapBsonDocToEquity (doc:BsonDocument) = { _id = new BsonObjectId(doc.["_id"].AsObjectId);
                                                  ShareIndex = doc.["ShareIndex"].AsString;
                                                  OpenPrice = decimal doc.["OpenPrice"].AsString;
                                                  ClosePrice = decimal doc.["ClosePrice"].AsString;
                                                  DividendYield = decimal doc.["DividendYield"].AsString;
                                                  MarketCap = doc.["MarketCap"].AsString;
                                                  PeRatio = doc.["PeRatio"].AsString;
                                                  DateRetrieved = doc.["DateRetrieved"].AsDateTime;
                                                  DateOfPrice = doc.["DateOfPrice"].AsDateTime;
                                                  Volume = if doc.Contains("Volume") && doc.["Volume"].BsonType <> BsonType.Null then doc.["Volume"].AsString else null;
                                                  Sector = if doc.Contains("Sector") && doc.["Sector"].BsonType <> BsonType.Null then doc.["Sector"].AsString else "";
                                                  Eps = if doc.Contains("Eps") && doc.["Eps"].BsonType <> BsonType.Null then doc.["Eps"].AsString else null;
                                                  ShareName = if doc.Contains("ShareName") && doc.["ShareName"].BsonType <> BsonType.Null then doc.["ShareName"].AsString else null;
                                                  Latest = doc.["Latest"].AsBoolean;
                                                  HighPrice = decimal doc.["HighPrice"].AsString;
                                                  LowPrice = decimal doc.["LowPrice"].AsString;
                                                  }

    let nullCheckEquity (res:System.Collections.Generic.IEnumerable<BsonDocument>) = List.ofSeq(res) |> List.iter (fun x -> printfn "%s" (x.ToJson()))
    let convertToEquityList (res:System.Collections.Generic.IEnumerable<BsonDocument>) = List.ofSeq(res) |> List.map (fun x -> mapBsonDocToEquity x)

    let appSettingsReader = new System.Configuration.AppSettingsReader()

    let dbName = appSettingsReader.GetValue("MongoDb", typeof<string>).ToString()
    //let username = appSettingsReader.GetValue("MongoUsername", typeof<string>).ToString()
    //let password = appSettingsReader.GetValue("MongoPassword", typeof<string>).ToString()
    //let credential = MongoCredential.CreateMongoCRCredential("admin", username, password);


    //let credentials = new System.Collections.Generic.List<MongoCredential>()

    //credentials.Add(credential)

    //let settings = new MongoClientSettings ( Credentials = credentials )

    let client = new MongoClient();
    let server = client.GetServer();

    let db = server.GetDatabase(dbName)

    let equityCollection = db.GetCollection<Equity> "Equity"
    let equityCollectionBson = db.GetCollection<BsonDocument> "Equity"

    let GetTopNEquitiesOnOrBefore (date:System.DateTime) (shareIndex:string) (noOfResults:int)=
      let query = equityCollectionBson.Find(Query.And(
                                            Query.EQ("ShareIndex",BsonValue.Create(shareIndex)),
                                            Query.LTE("DateOfPrice", BsonValue.Create(date)),
                                            Query.EQ("Latest",BsonValue.Create(true))
        ))

      let result = query.SetSortOrder(SortBy.Descending("DateOfPrice")).Take(noOfResults)
      convertToEquityList result

    let GetEquity (date:System.DateTime) (shareIndex:string) =
      let startDate = new System.DateTime(date.Year,date.Month, date.Day, 00,00,00)
      let endDate = new System.DateTime(date.Year,date.Month, date.Day, 23,59,59)

      let results = equityCollection.Find(Query.And(
                                            Query.EQ("ShareIndex",BsonValue.Create(shareIndex)),
                                            Query.GT("DateOfPrice",BsonValue.Create(startDate)),
                                            Query.LT("DateOfPrice",BsonValue.Create(endDate)),
                                            Query.EQ("Latest", BsonValue.Create(true))
                                   ))
      results.First()

    let GetClosePrices (shareIndex : string, startDate : DateTime) =
        let results = equityCollection.Find(Query.And(
                                                Query.EQ("ShareIndex",BsonValue.Create(shareIndex)),
                                                Query.GT("DateOfPrice",BsonValue.Create(startDate))
                        ))

        //let returnResults = List.ofSeq(results.ToList()) |> List.map (fun x -> { ShareIndex = x.["ShareIndex"].AsString})

        results.ToList()

    let GetAllLatestForDate (date: DateTime) =
      let startDate = new System.DateTime(date.Year,date.Month, date.Day, 00,00,00)
      let endDate = new System.DateTime(date.Year,date.Month, date.Day, 23,59,59)


      let results = equityCollectionBson.Find(Query.And(
                                                        Query.GT("DateOfPrice",BsonValue.Create(startDate)),
                                                        Query.LT("DateOfPrice",BsonValue.Create(endDate)),
                                                        Query.EQ("Latest", BsonValue.Create(true))))

      convertToEquityList results
