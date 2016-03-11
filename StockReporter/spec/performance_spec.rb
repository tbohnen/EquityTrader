require_relative '../Queries/equity_queries'
require_relative '../Reports/daily_stocks_report'

describe "Performance Tests" do

 it "should get a given equity under given time" do
   daily_stocks_report = DailyStocksReport.new
   equity_queries = EquityQueries.new
   date = Time.utc(2014,12,1)

   shares = equity_queries.get_highest_52wkGrowth(date)

   selected_shares = shares.take(1).to_a

   start_time = Time.now
   daily_stocks_report.get_rows(selected_shares, date)
   end_time = Time.now

   expect(end_time - start_time).to be < 3
 end

 it "get all stocks for given date should return in less than x" do
   equity_queries = EquityQueries.new

   start_time = Time.now

   equity_queries.get_highest_52wkGrowth(Time.utc(2014,12,1))

   end_time = Time.now

   expect(end_time - start_time).to be < 5
 end

end
