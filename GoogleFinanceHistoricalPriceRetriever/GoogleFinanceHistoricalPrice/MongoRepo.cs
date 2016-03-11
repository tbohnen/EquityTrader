using MongoDB.Driver;
using MongoDB.Driver.Linq;
using System;
using System.Linq;
using System.Configuration;

namespace GoogleFinanceHistoricalPrice
{
    public class MongoRepository<T>
    {
        private readonly MongoCollection<T> _collection;

        public MongoRepository()
        {
            var client = new MongoClient(); // connect to localhost
            var server = client.GetServer();
            var database = ConfigurationManager.AppSettings["database"];
            var stockAnalyzer = server.GetDatabase("stockanalyzer");
            _collection = stockAnalyzer.GetCollection<T>(typeof(T).Name);
            Console.WriteLine("Db Name: " + database);
        }

        public void Insert(T item)
        {
            _collection.Save(item);
        }

        public IQueryable<T> Query()
        {
            return _collection.AsQueryable<T>();
        }
    }
}
