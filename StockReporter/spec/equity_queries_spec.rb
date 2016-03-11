require_relative '../Queries/equity_queries'


describe EquityQueries do

  before(:all) do
    @equity_queries = EquityQueries.new
  end

  it "Should return 22 prices" do

    date = Time.utc(2014,10,7)

    previous_prices = @equity_queries.get_previous_prices(date, 22, "SHF")

    expect(previous_prices.count).to eq 22
  end

  it "Get Highest 52 week growth for 2014 10 20 and whl" do

    shares = @equity_queries.get_highest_52wkGrowth(Time.utc(2014,10,20))

    found_share = shares.any? {|share| share["ShareIndex"] == "WHL"}

    expect(found_share).to eq true 

  end

  it "Get Highest 52 week growth for 2014 10 20" do

    shares = @equity_queries.get_highest_52wkGrowth(Time.utc(2014,10,20))

    expect(shares.count{|s| s["FiftyTwoWkGrowth"].to_f != 0}).to eq 339

  end


  it "should return current price for share on date" do
    date = Time.utc(2014,10,7)

    close_price = @equity_queries.get_close_price("WHL", date)

    expect(close_price).to eq 7156

  end

  it "should return equity for share on date" do
    date = Time.utc(2014,10,8)

    equity = @equity_queries.get_share("DBXUS", date)

    expect(equity["ShareIndex"]).to eq "DBXUS"
    expect(equity["ClosePrice"].to_f).to eq 2066
  end

end
