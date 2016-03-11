using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net.Http;
using NUnit.Framework;

namespace GoogleFinanceHistoricalPrice
{
    public class FileDownloader
    {
        private const string StagingFolder = "staging";

        public void AddFilesToRepo(bool demo = false)
        {
            Console.WriteLine(Directory.Exists(StagingFolder));
            var files = Directory.GetFiles(String.Format("{0}/",StagingFolder));
            var mongoRep = new MongoRepository<Equity>();
            var companyRep = new MongoRepository<Company>();
            var codes = new List<string>();

            Console.WriteLine("Files count" + files.Count());

            foreach (var file in files)
            {
                var lines = File.ReadAllLines(file);
                if (lines[0].StartsWith("<html>")) continue;

                var fi = new FileInfo(file);
                var shareIndex = fi.Name.Replace(".csv", "");

                Console.WriteLine("Read: " + shareIndex);

                if (companyRep.Query().Count(c => c.ShareIndex == shareIndex) == 0){
                var company = new Company(){
                    ShareIndex = shareIndex 
                };
                companyRep.Insert(company);
                }

                var allLinesForEquity = mongoRep.Query().Where(s => s.ShareIndex == shareIndex).ToList();

                foreach (var line in lines.Skip(1))
                {
                    var cols = line.Split(',');

                    var volume = cols[5] != "-" ? Convert.ToDecimal(cols[5]) : -1;

                    decimal openPrice = 0;
                    if (!String.IsNullOrEmpty(cols[1]) && cols[1] != "-")
                        openPrice = GetPrice(cols[1]);

                    decimal currentPrice = 0;
                    if (!String.IsNullOrEmpty(cols[4])) currentPrice = GetPrice(cols[4]);

                    var dateOfPrice = DateTime.ParseExact(cols[0], "d-MMM-yy", CultureInfo.CurrentCulture);
                    dateOfPrice = dateOfPrice.AddHours(2);

                    if (dateOfPrice > DateTime.Now) throw new Exception("oops");

                    if (cols[5].StartsWith("-")) cols[5] = "0";

                    var equities = allLinesForEquity.Where(s => s.DateOfPrice == dateOfPrice);

                    if (!equities.Any())
                    {
                        var equity = new Equity
                        {
                            ShareIndex = shareIndex,
                            DateOfPrice = dateOfPrice,
                            DateRetrieved = dateOfPrice,
                            ClosePrice = currentPrice,
                            OpenPrice = openPrice,
                            Volume = volume,
                            Latest = true
                        };
                        mongoRep.Insert(equity);
                        Console.WriteLine("Added new");
                    }
                    else
                    {
                        foreach (var equity in equities)
                        {
                            equity.OpenPrice = openPrice;
                            equity.ClosePrice = currentPrice;
                            if (equity.Volume == 0) equity.Volume = volume;
                            if (equity.DateOfPrice == null || equity.DateOfPrice == default(DateTime))
                                equity.DateOfPrice = dateOfPrice;

                            mongoRep.Insert(equity);
                        }
                        Console.WriteLine("Added existing");
                    }
                }
            }
        }


        public decimal GetPrice(string price)
        {
            return Convert.ToDecimal(price.Substring(0, price.IndexOf(".")));
        }

    }
}
