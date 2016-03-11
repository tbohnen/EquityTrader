require_relative '../email_stock_reporter'

describe EmailStockReporter do

  it "should return only given stuff" do
   email_stock_reporter = EmailStockReporter.new
   results = email_stock_reporter.send_my_stocks_report(Time.new(2014,10,20))
   expect(results.count).to eq 5
  end

end
