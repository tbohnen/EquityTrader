require_relative '../Reports/daily_close_stock_price_report'

describe DailyCloseStockPriceReport do
  it "Should return the close price for a stock over a given start and end date" do
    start_date = Time.utc(2014,11,03).to_s
    end_date = Time.utc(2014,11,28).to_s
    share_index = "SHF"

    params = {:shareindex => share_index, :startdate => start_date, :enddate => end_date}

    report = DailyCloseStockPriceReport.new
    rows = report.generate(params)

    expect(rows[0].closePrice).to eq 5685
    expect(rows[0].date).to eq Time.utc(2014,11,03,15,7)
    expect(rows[rows.count - 1].closePrice).to eq 5835
    expect(rows[rows.count - 1].date).to eq Time.utc(2014,11,27,15,40)
  end
end
