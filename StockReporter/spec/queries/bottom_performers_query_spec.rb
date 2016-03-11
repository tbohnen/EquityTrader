require_relative '../../Queries/bottom_performers_query'
require_relative '../test_data_creator'

describe BottomPerformersQuery do

  before(:each) do

    TestData.create_demo_company("TST1", "Test1", "Equity")
    TestData.create_demo_company("TST2", "Test2", "Equity")
    TestData.create_demo_company("TST3", "Test3", "Equity")
    TestData.create_demo_company("TST4", "Test4", "NonEquity")

    TestData.create_technical_data(
      { :ShareIndex => "TST4",
        :Date => Time.utc(2015,5,10),
        :DailyMovement => 1,
        :Official => true
      })

    TestData.create_technical_data(
      { :ShareIndex => "TST3",
        :Date => Time.utc(2015,5,10),
        :DailyMovement => 6,
        :Official => true
      })

    TestData.create_technical_data(
      { :ShareIndex => "TST2",
        :Date => Time.utc(2015,5,10),
        :DailyMovement => 5,
        :Official => true
      })

    TestData.create_technical_data(
      { :ShareIndex => "TST1",
        :Date => Time.utc(2015,5,10),
        :DailyMovement => 4,
        :Official => true
      })

  end

  context "Should return the bottom n number of queries" do
    it "Will return the bottom 10 performers when requested" do
      query = BottomPerformersQuery.new

      results = query.query(:date => Time.utc(2015,5,10))

      expect(results[0][:ShareIndex]).to eq "TST1"
      expect(results[1][:ShareIndex]).to eq "TST2"
      expect(results[2][:ShareIndex]).to eq "TST3"

    end

    it "Should not include non equities in count" do
      query = BottomPerformersQuery.new

      results = query.query(:date => Time.utc(2015,5,10))

      expect(results.count).to eq 3
    end
  end
end
