require_relative '../Queries/latest_equity_date_query'
require_relative '../Repositories/mongo_repository'

describe LatestEquityDateQuery do
  before(:each) do
    @repo = MongoRepository.new("Equity")
    @latest_time = Time.now.utc
    insert_equity(@latest_time, true)
  end

  after(:each) do
    @repo.remove_by_query({"DateOfPrice" => @latest_time})
  end

  it "Should return the latest DateOfPrice from Equities" do
    query = LatestEquityDateQuery.new

    date = query.query()

    expect(Time.utc(date.year, date.month, date.day)).to eq Time.utc(@latest_time.year, @latest_time.month, @latest_time.day)
  end

  it "Should only return date for Equity where it's marked as Latest" do

    future_date = Time.utc(@latest_time.year + 1, 1,1)

    insert_equity(future_date, false)


    query = LatestEquityDateQuery.new

    date = query.query()

    expect(Time.utc(date.year, date.month, date.day)).to_not eq Time.utc(future_date.year, future_date.month, future_date.day)
    expect(Time.utc(date.year, date.month, date.day)).to eq Time.utc(@latest_time.year, @latest_time.month, @latest_time.day)


    @repo.remove_by_query({"DateOfPrice" => future_date})
  end

    def insert_equity(date, latest)
      @repo.insert({"DateOfPrice" => date, "Latest" => latest })
    end

end

