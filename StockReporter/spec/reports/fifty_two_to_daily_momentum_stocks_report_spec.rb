require_relative '../test_data_creator'
require_relative '../../Reports/query_report'
require_relative '../../Queries/fifty_two_to_daily_momentum_stocks_query'

describe "FiftyTwoToDailyMomentumStocksReport" do

  before(:each) do

    TestData.create_technical_data(
      { :ShareIndex => "TstNegative",
        :Date => Time.utc(2015,12,1),
        :DailyMovement => -1,
        :OneYearGrowth =>1,
        :SixMonthGrowth => 1,
        :FourWkGrowth => 1,
        :Official => true
      })

    TestData.create_technical_data(
      { :ShareIndex => "TstPositive",
        :Date => Time.utc(2015,12,1),
        :DailyMovement => 1,
        :OneYearGrowth =>1,
        :SixMonthGrowth => 1,
        :FourWkGrowth => 1,
        :Official => true
      })

  end


  it "Should return only stocks that have a positive growth over 52 weeks, 31 weeks and 4 weeks as well daily" do
    report = QueryReport.new()
    result = report.generate({ "query" => "FiftyTwoToDailyMomentumStocksQuery", "date" => Date.new(2015,12,1)})

    expect(result.count).to eq 1
    expect(result[0]["ShareIndex"]).to eq "TstPositive"
  end

end
