using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GoogleFinanceHistoricalPrice.Console
{
    class Program
    {
        static void Main(string[] args)
        {
          var demo = false;

          System.Console.WriteLine("Starting with arguments: ");
          foreach (var arg in args) System.Console.WriteLine(arg);

          if (args[0] == "existing")
          {
            System.Console.WriteLine("Importing existing");
            var fd = new FileDownloader();
            fd.AddFilesToRepo(demo);
          }

        }
    }
}
