ENV['RACK_ENV'] = 'test'

require_relative '../reports_service'
require 'rack/test'
require 'json'
require_relative '../../StockReporter/Repositories/mongo_repository'
require_relative '../../StockReporter/spec/test_data_creator'

describe "ReportsService" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "Should delete an my equities transaction" do
    repo = MongoRepository.new("MyEquities")

    my_share = create_share_transaction()

    my_share_id = my_share["_id"]

    response = post "/deleteMySharesTransaction/" + my_share_id.to_s

    exists = repo.find_by_query({"_id" => my_share_id}).to_a.any?

    expect(response).to be_ok
    expect(exists).to eq false
  end

  def create_share_transaction

    repo = MongoRepository.new("MyEquities")

    share_transaction = { 
      "ShareIndex" => "SHF", 
      "PurchasePrice" => 1,
      "NoOfShares" => 1,
      "UserId" => BSON::ObjectId("54d8f0ee954ab50c440000f4") ,
      "DateOfPurchase" => Time.utc(2015,1,1)
    }

    repo.insert(share_transaction)

    my_share = repo.find_by_query(share_transaction).find.to_a[0]

    return my_share
  end

  # it "Should return the expected total return per year" do
  #   minimum_market_cap = 10000000000 
  #   number_of_biggest_industries = 5
  #   number_of_top_performers = 1
  #   response = get "/strategy/industryBest?mimimumMarketCap=#{minimum_market_cap}&numberOfBiggestIndustries=#{number_of_biggest_industries}&numberOfTopPerformers=#{number_of_top_performers}"
  #   body = JSON.parse(response.body)

  #   expect(body[0]["key"]).to eq "1000000000051"
  #   expect(body[0]["totalGrowth"]).to eq 1.947449231382897
  #   expect(body[0]["mean"]).to eq 0.21638324793143301
  #   expect(body[0]["stdDev"]).to eq 0.1761354852304525
  # end

  it "Should return the latest dashboard for a given user" do

    user_id = TestData.create_demo_user()["_id"]

    TestData.create_demo_equity("SHF",Time.utc(2015,1,7), 10)
    TestData.create_demo_my_equity("SHF", Time.utc(2015,1,7),1,user_id,90)

    response = get "/dashboard?userId=#{user_id.to_s}"

    body = JSON.parse(response.body)

    expect(body["Rows"].count).to be > 0
    expect(response).to be_ok
  end

  it "Should execute report correctly without user id" do

    TestData.create_demo_company("SHF","SHF", "Equity")
    TestData.create_demo_equity("SHF",Time.utc(2015,1,7), 10)

    response = get '/report/DailyStocksReport?date=7-Jan-2015'

    body = JSON.parse(response.body)

    expect(body["Rows"].count).to be > 0
    expect(response).to be_ok
  end

  it "Should execute the fifty two to daily query report and return correct result" do

     TestData.create_technical_data(
                                                                 { "ShareIndex" => "TSTNeg",
                                                                  "Date" => Time.utc(2015,1,7),
                                                                  :OneYearGrowth => -1,
                                                                  :SixMonthGrowth => 2,
                                                                  :FourWkGrowth => 2,
                                                                  :DailyMovement => 2,
                                                                  :Official => true
                                                                 })

      TestData.create_technical_data(
                                                                 { "ShareIndex" => "TSTPos",
                                                                  "Date" => Time.utc(2015,1,7),
                                                                  :OneYearGrowth => 2,
                                                                  :SixMonthGrowth => 2,
                                                                  :FourWkGrowth => 2,
                                                                  :DailyMovement => 2,
                                                                  :Official => true
                                                                 })

    response = get '/report/queryreport/FiftyTwoToDailyMomentumStocksQuery?date=7-Jan-2015'

    body = JSON.parse(response.body)

    expect(body["Rows"].count).to be 1
    expect(body["Rows"][0]["ShareIndex"]).to eq "TSTPos"
    expect(response).to be_ok
  end

  it "Should execute report correctly with user id" do

    user_id = TestData.create_demo_user()["_id"]
    TestData.create_demo_equity("TST1",Time.utc(2015,1,7),100)
    TestData.create_demo_equity("TST1",Time.utc(2015,1,7),100)
    TestData.create_demo_equity("TST1",Time.utc(2015,1,8),100)
    TestData.create_demo_my_equity("TST1", Time.utc(2015,1,6),1,user_id,90)

    response = get "/report/MyStocksReport?date=8-Jan-2015&userId=#{user_id}"

    expect(response).to be_ok

    body = JSON.parse(response.body) 

    expect(body["Rows"].count).to be > 0
    expect(response.status).to eq 200
  end

  it "adds a new user and returns response 200 and not empty response" do
    #TODO: randomize or delete after done...
    testEmail = "testasdf@gmail.com"
    responseMsg = post '/addUser/' + testEmail

    body = JSON.parse(responseMsg.body) 

    expect(responseMsg.status).to eq 200

    expect(body["id"].nil?).to eq false
  end

  it "Does not create a new user but returns existing id instead" do
    existing_user = TestData.create_demo_user()
    existing_id = existing_user["_id"]

    responseMsg = post '/addUser/' + existing_user["Email"]

    body = JSON.parse(responseMsg.body)

    expect(responseMsg.status).to eq 200

    expect(body["id"]).to eq existing_id.to_s

  end

end
