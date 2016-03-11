using System;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace GoogleFinanceHistoricalPrice
{
    public class Company
    {
        public Company()
        {
        }

        [BsonId]
        public ObjectId _id { get; set; }

        public string ShareIndex { get; set; }
        public string CompanyName {get; set; }
        public String Sector { get; set;  }
        public String Industry { get; set;  }
    }
}
