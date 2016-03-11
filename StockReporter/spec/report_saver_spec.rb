require_relative '../Reports/report_saver'
require_relative '../Reports/single_stock_macd_report'
require_relative '../Reports/daily_stocks_report'

describe ReportSaver do

  it "Should save the rows of the report for the MACD Test report" do
    single_stock_macd_report = SingleStockMacdReport.new
    report_saver = ReportSaver.new(single_stock_macd_report)
    share_index = "WHL"
    start_date = Time.new(2014,11,1)
    end_date = Time.new(2014,11,4)

    report_saver.save(share_index, start_date, end_date)

  end

  it "Should save the rows of the report for the MACD Test report" do
  end

  it "Should save the rows of the report for the MACD Test report" do
    daily_stocks_report = DailyStocksReport.new
    report_saver = ReportSaver.new(daily_stocks_report)

    date = Time.new(2014,12,1)

    report_saver.save(date)
  end
end

