using System;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace GoogleFinanceHistoricalPrice
{
    public class Equity
    {
        public Equity()
        {
            DateRetrieved = DateTime.Now;
        }

        [BsonId]
        public ObjectId _id { get; set; }

        public string ShareIndex { get; set; }
        public Decimal OpenPrice { get; set; }
        public decimal YTDGrowth { get; set; }
        public decimal ClosePrice { get; set; }
        public decimal FiftyTwoWkGrowth { get; set; }
        public decimal FourWkGrowth { get; set; }
        public decimal DividendYield { get; set; }
        public decimal MarketCap { get; set; }
        public decimal PeRatio { get; set; }
        public DateTime DateRetrieved { get; set; }
        public decimal SixMonthGrowth { get; set; }
        public DateTime DateOfPrice { get; set; }
        public decimal Volume { get; set; }
        public string Sector {get; set;}
        public string Eps {get; set;}
        public string ShareName {get; set;}
        public bool Latest {get; set;}
        public decimal HighPrice {get; set;}
        public decimal LowPrice {get; set;}
    }
}
