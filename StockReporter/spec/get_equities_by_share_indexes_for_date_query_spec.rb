require_relative '../Queries/get_equities_by_share_indexes_for_date_query.rb'
require_relative 'test_data_creator'

describe GetEquitiesByTypeForDate do

   before(:all) do
     @demo_company1 = TestData.create_demo_company("TST1", "Test1", "Equity")
     @demo_company2 = TestData.create_demo_company("TST2", "Test1", "NotEquity")


     @demo_equity1 = TestData.create_demo_equity("TST1", Time.utc(2014,12,1), 100)
     @demo_equity2 = TestData.create_demo_equity("TST2", Time.utc(2014,12,1), 100)

   end

  context "When querying for all types on a give date" do
    it "should return only equities matched on that type" do

      query = GetEquitiesByTypeForDate.new

      equities = query.query(:date => Time.utc(2014,12,1), :type => "Equity")

      expect(equities.count).to eq 1
    end
  end
end
