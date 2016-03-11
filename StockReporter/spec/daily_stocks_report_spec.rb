require_relative '../Reports/daily_stocks_report'

describe DailyStocksReport do
  it "Should return all the stocks for the given day" do
    daily_stocks_report = DailyStocksReport.new

    date = Time.new(2014,12,1)
    result = daily_stocks_report.generate(date)

    expect(result.count).to eq 472

    shf = result.find{|e| e["ShareIndex"] == "SHF" }

    expect(shf.ShareIndex).to eq "SHF"
    expect(shf.ShareName).to eq nil
    expect(shf.DateOfPrice).to eq "2014-12-01 15:21:00 UTC"
    expect(shf.Volume).to eq "13241491"
    expect(shf.MarketCap).to eq "0"
    expect(shf.PeRatio).to eq "12.61"
    expect(shf.OpenPrice).to eq "5800.00"
    expect(shf.ClosePrice).to eq "5800"
    expect(shf.DailyMovement).to eq (-0.34)
    expect(shf.FiveYearGrowth).to eq (-1)
    expect(shf.ThreeYearGrowth).to eq 135.77
    expect(shf.FiftyTwoWkGrowth).to eq 43.56
    expect(shf.SixMonthGrowth).to eq 7.23
    expect(shf.FourWkGrowth).to eq 2.02
    expect(shf.EarningsPerShare).to eq nil
    expect(shf.EMA22).to eq 5381.36
    expect(shf.Sector).to eq "Household Goods & Home Construction"
    expect(shf.Industry).to eq "Consumer Goods"
  end
end

