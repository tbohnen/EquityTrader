require_relative '../Reports/daily_top_performers_report'
require_relative 'test_data_creator'


describe DailyTopPerformersReport do

  before(:each) do
    TestData.create_demo_equity("CGR", Time.new(2015,5,10), 1)
    TestData.create_demo_equity("CGR", Time.new(2015,5,11), 10000)
  end

  it "Should return the company name" do
    report = DailyTopPerformersReport.new
    rows = report.generate(Time.utc(2015,5,11))

    calgro = rows.first{ |r| r["ShareName"] == "Calgro M3 Hldgs Ltd" }

    expect(calgro).not_to be_nil
  end
end


