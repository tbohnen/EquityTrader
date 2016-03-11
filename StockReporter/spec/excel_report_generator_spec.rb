require_relative '../Reports/excel_report_generator'
require_relative '../Reports/single_stock_macd_report'

describe ExcelReportGenerator do
  it "should generate the macd report and dump it to the given file" do
    single_stock_macd_report = SingleStockMacdReport.new
    report_generator = ExcelReportGenerator.new(single_stock_macd_report)

    share_index = "SHF"
    start_date = Time.new(2014,4,1)
    end_date = Time.new(2014,5,29)

    file_name = "macd_#{share_index}_#{start_date.strftime("%Y-%m-%d")}_#{end_date.strftime("%Y-%m-%d")}"

    report_generator.save_as(file_name,share_index,start_date,end_date)
    File.exists?(file_name + ".xls")
  end

end
