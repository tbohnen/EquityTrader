require_relative '../Reports/my_stocks_summary_report'
require_relative 'test_data_creator'

describe MyStocksSummaryReport do

   before(:all) do
     @test_user = TestData.create_demo_user
     @demo_equity1 = TestData.create_demo_equity("TST1", Time.utc(2014,12,1), 100)
     @demo_equity2 = TestData.create_demo_equity("TST1", Time.utc(2014,12,2), 111)

     @demo_equity3 = TestData.create_demo_equity("TST2", Time.utc(2014,12,1), 50)
     @demo_equity4 = TestData.create_demo_equity("TST2", Time.utc(2014,12,2), 100)

     @demo_my_equity = TestData.create_demo_my_equity("TST1", Time.utc(2014,12,1), 10, @test_user["_id"], 98)
     @demo_my_equity = TestData.create_demo_my_equity("TST2", Time.utc(2014,12,1), 10, @test_user["_id"], 60)

     @demo_technical_indicator1 = TestData.create_technical_data(
                                                                 { "ShareIndex" => "TST1",
                                                                  "Date" => Time.utc(2014,12,2),
                                                                  :DailyMovement => 4
                                                                 })

     @demo_technical_indicator2 = TestData.create_technical_data(
                                                                 { "ShareIndex" => "TST2",
                                                                  "Date" => Time.utc(2014,12,2),
                                                                  :DailyMovement => 2
                                                                 })
   end

   it "Correct Strongest Total and Daily Share returned" do
     report = MyStocksSummaryReport.new()
     date = Time.new(2014,12,2)
     user_id = @test_user["_id"]
     rows = report.generate(date, user_id)
     data = rows.first

     expect(data.Date).to eq(Time.utc(date.year, date.month, date.day, 00,00))
     expect(data.StrongestShareOverall[:ShareIndex]).to eq ("TST2")
     expect(data.StrongestDailyShare[:ShareIndex]).to eq ("TST1")
   end

   it "Correct Weakest Total and Daily Share returned" do
     report = MyStocksSummaryReport.new()
     date = Time.new(2014,12,2)
     user_id = @test_user["_id"]
     rows = report.generate(date, user_id)
     data = rows.first

     expect(data.Date).to eq(Time.utc(date.year, date.month, date.day, 00,00))
     expect(data.WeakestShareOverall[:ShareIndex]).to eq ("TST1")
     expect(data.WeakestDailyShare[:ShareIndex]).to eq ("TST2")
   end

  # it "Should have all the correct indicators for a given day" do
  #   report = MyStocksSummaryReport.new()

  #   date = Time.new(2015,1,23)
  #   user_id = BSON::ObjectId('54da1b7fc75928d3c3683c75')
  #   Time.new
  #   rows = report.generate(date, user_id)
  #   data = rows.first

  #   expect(data.DailyAverage).to eq(1.35)
  #   expect(data.TotalMovement).to eq(7.03)
  #   expect(data.StrongestShareOverall[:ShareIndex]).to eq("APN")
  #   expect(data.WeakestShareOverall[:ShareIndex]).to eq("CGR")
  #   expect(data.StrongestDailyShare[:ShareIndex]).to eq ("EOH")
  #   expect(data.WeakestDailyShare[:ShareIndex]).to eq ("SHF")
  #   expect(data.PortfolioUnitPrice).to eq (90729.0)
  #   expect(data.PortfolioOverallValue).to eq (90729.0 + 1927.0)
  # end
end
