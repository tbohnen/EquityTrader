require_relative '../Repositories/mongo_repository'

class TopFortySharesForDateQuery

  def initialize
    @repo = MongoRepository.new('Equity')
  end
  def query(params)

    date = params[:date]
    start_date = Time.utc(date.year, date.month, date.day, 0, 0)
    end_date = Time.utc(date.year, date.month, date.day, 23, 59)

    query = {:$and => 
      [ {:DateOfPrice => {"$gte" => start_date}}, 
        {:DateOfPrice => {"$lte" => end_date}},
        {:Sector => { "$ne" => "ALTX (ALTX)"}},
        {:Latest => true}
      ]}

    # this should be the correct way to do it but currently market cap stored as string...
    #return @repo.find_by_query(query, {:sort =>{ "MarketCap" => 1 } ,:limit => 40}).to_a
    
    return @repo.find_by_query(query)
      .to_a
      .sort { |a, b| b["MarketCap"].to_f <=> a["MarketCap"].to_f}
      .take(40)
    
  end

end
