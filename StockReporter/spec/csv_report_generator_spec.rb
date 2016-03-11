require_relative '../Reports/csv_report_generator'
require_relative '../Reports/single_stock_macd_report'

describe CsvReportGenerator do
  it "should generate the macd report and dump it to the given file" do
    single_stock_macd_report = SingleStockMacdReport.new
    report_generator = CsvReportGenerator.new(single_stock_macd_report)

    share_index = "SHF"
    start_date = Time.new(2014,9,2)
    end_date = Time.new(2014,9,10)
    file_name = "macd_#{share_index}_#{start_date.strftime("%Y-%m-%d")}_#{end_date.strftime("%Y-%m-%d")}"

    report_generator.save_as(file_name,share_index,start_date,end_date)
  end
end
