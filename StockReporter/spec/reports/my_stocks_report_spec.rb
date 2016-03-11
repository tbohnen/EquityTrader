require_relative '../../Reports/my_stocks_report'
require_relative '../../Repositories/mongo_repository'

describe MyStocksReport do
  before(:all) do
    setup_duplicate_shares

    report = MyStocksReport.new
    date = Time.new(2015,4,1)
    user_id = BSON::ObjectId("54d8f0ee954ab50c440000f4")

    @rows = report.generate(date, user_id)

    @fsr_share = @rows.find{|e| e["ShareIndex"] == "FSR" }
  end

  it "Should only return the stocks for a given user" do

    report = MyStocksReport.new
    date = Time.new(2015,1,5)
    user_id = BSON::ObjectId("54d8f0ee954ab50c440000f4")

    rows = report.generate(date, user_id)

    expect(rows.count).to be > 0
  end

  it "Multiple shares should be conbined into one share" do
    count = @rows.count{|e| e["ShareIndex"] == "FSR" }

    expect(count).to eq 1
    expect(@fsr_share.ShareName).to eq 'FirstRand Limited'
    expect(@fsr_share.DateOfPrice.strftime "%Y-%m-%d").to eq '2015-04-01'
    expect(@fsr_share.Volume).to eq '4480000.00'
    expect(@fsr_share.PeRatio).to eq '15.51'
    expect(@fsr_share.ClosePrice).to eq '5596.00'
    expect(@fsr_share.DailyMovement).to eq 0.21
    expect(@fsr_share.FiveYearGrowth).to eq -1
    expect(@fsr_share.ThreeYearGrowth).to eq 137.52
    expect(@fsr_share.FiftyTwoWkGrowth).to eq 53.74
    expect(@fsr_share.SixMonthGrowth).to eq 30.75
    expect(@fsr_share.FourWkGrowth).to eq -1
    expect(@fsr_share.RelativeStrength).to eq 2.22
    expect(@fsr_share.Sector).to eq 'Banks'
    expect(@fsr_share.Industry).to eq 'Financials'
  end

  it "Should return total days as transaction that's been bought longest ago" do
    expect(@fsr_share.DaysHeld).to eq 60
  end

  it "Should return the total number of shares still held minus sold shares" do
    expect(@fsr_share.NoOfShares).to eq 120
  end
  
  it "Should show the current value as (number of shares * current price) - (no of sold shares * sell price)" do
    expect(@fsr_share.CurrentValue).to eq 6729.2
  end

  it "Should return the purchase value with fifo for sales" do
    expect(@fsr_share.PurchaseValue).to eq 6507.90
  end

  it "Should return the correct percentage per portfolio" do
    expect(@fsr_share.PercentageOfPortfolio).to eq 14.33
  end

  it "Should calculate the total movement based on the number of shares not sold similar to current value" do
    expect(@fsr_share.TotalMovement).to eq 3.40
  end

  it "Should return average return per day"  do
    expect(@fsr_share.DailyAverage).to eq 0.06
  end

end

private


  def setup_duplicate_shares

    my_equities_repo = MongoRepository.new('MyEquities')

    share1 = { 
      "ShareIndex" => "FSR",
      "DateOfPurchase" => Time.utc(2015,1,30),
      "PurchasePrice" => 5208,
      "NoOfShares" => 50,
      "UserId" => BSON::ObjectId("54d8f0ee954ab50c440000f4")
    }

    share2 = { 
      "ShareIndex" => "FSR",
      "DateOfPurchase" => Time.utc(2015,3,24),
      "PurchasePrice" => 5495,
      "NoOfShares" => 90,
      "UserId" => BSON::ObjectId("54d8f0ee954ab50c440000f4")
    }

    share3 = { 
      "ShareIndex" => "FSR",
      "DateOfPurchase" => Time.utc(2015,3,31),
      "PurchasePrice" => 5526,
      "NoOfShares" => -20,
      "UserId" => BSON::ObjectId("54d8f0ee954ab50c440000f4")
    }

    my_equities_repo.remove_by_query({ "ShareIndex" => "FSR" }) 

    my_equities_repo.insert(share1) 
    my_equities_repo.insert(share2) 
    my_equities_repo.insert(share3) 

  end
