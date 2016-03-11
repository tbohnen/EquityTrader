require_relative '../../Reports/my_watchlist_report'
require_relative '../../Repositories/mongo_repository'

describe MyWatchlistReport do

  before(:each) do
    @users_repo = MongoRepository.new("Users")
    @watchlist_repo = MongoRepository.new("MyWatchlist")

    @latest_time = Time.now.utc
    @date = Time.utc(2014,12,1)
    @users_repo.insert({"Email" => "TestUser@gmail.com"})
    @users_repo.insert({"Email" => "DifferentTestUser@gmail.com"})

    @user_id = @users_repo.find_by_query({"Email" => "TestUser@gmail.com"}).first["_id"]
    @different_user_id = @users_repo.find_by_query({"Email" => "DifferentTestUser@gmail.com"}).first["_id"]

    @watchlist_repo.insert({:ShareIndex => "D101", 
                            :DateAdded => @date,
                            :UserId =>  @user_id,
                            :Price => 100 })
  end

  after(:each) do
    @users_repo.remove_by_query({"Email" => "DifferentTestUser@gmail.com"})
    @users_repo.remove_by_query({"Email" => "TestUser@gmail.com"})
    @watchlist_repo.remove_by_query({:ShareIndex => "D101", :Price => 100})
  end

  it "Should not return watchlist item for different user" do
    report = MyWatchlistReport.new

    result = report.generate(@date, @different_user_id)

    expect(result.count).to eq 0
  end

  it "Should Return Watchlist with item for given date" do
    report = MyWatchlistReport.new

    result = report.generate(@date, @user_id)

    expect(result.count).to be > 0
    expect(result[0]["ShareIndex"]).to eq "D101"
    expect(result[0]["Price"]).to eq 100
    expect(result[0]["DateAdded"]).to eq @date

  end

end

