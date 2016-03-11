require_relative '../Queries/previous_close_query'

describe PreviousClosePriceQuery do
  it "should return the previous close price for the given query" do
    query = PreviousClosePriceQuery.new
    previous_close = query.query("WHL", Time.new(2014,10,20))
    expect(previous_close).to eq 7011
  end
end
