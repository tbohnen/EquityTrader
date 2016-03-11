require_relative '../Queries/day_movement_query'

describe DayMovementQuery do
  it "should return list of stocks with only given stocks" do
    day_movement_query = DayMovementQuery.new

    entities = ["APN","WHL"]
    day = Time.new(2014,10,20)
    
    returned_equities = day_movement_query.query(entities, day)

    expect(returned_equities.count).to eq 2
    expect(returned_equities.to_a.any?{|e| e["ShareIndex"] == "WHL"}).to eq true
    expect(returned_equities.to_a.any?{|e| e["ShareIndex"] == "APN"}).to eq true
  end

  it "should return only requested stock with exact close price for given day" do
    day_movement_query = DayMovementQuery.new

    share_index = "APN"
    day = Time.new(2014,10,20)

    entities = [share_index]
    
    returned_equities = day_movement_query.query(entities, day)

    expect(returned_equities[0]["ShareIndex"]).to eq share_index
    expect(returned_equities[0]["ClosePrice"].to_f).to eq 34570
  end

  it "should return movement over a weekend" do
    day_movement_query = DayMovementQuery.new

    share_index = "SHF"
    day = Time.new(2014,11,24)

    entities = [share_index]
    
    returned_equities = day_movement_query.query(entities, day)

    expect(returned_equities[0]["ShareIndex"]).to eq share_index
    expect(returned_equities[0]["ClosePrice"].to_f).to eq 34570
  end
end
