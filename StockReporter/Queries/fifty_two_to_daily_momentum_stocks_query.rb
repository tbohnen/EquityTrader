class FiftyTwoToDailyMomentumStocksQuery
  def initialize
    @repo = MongoRepository.new("TechnicalIndicator")
  end

  def query(params)
    date = params["date"]

    start_date = Time.utc(date.year, date.month, date.day, 0, 0)
    end_date = Time.utc(date.year, date.month, date.day, 23, 59)

    query = {:$and =>
      [ {:Date => {"$gte" => start_date}},
      {:Date => {"$lte" => end_date}},
      {:OneYearGrowth => {"$gt" => 0}},
      {:SixMonthGrowth => {"$gt" => 0}},
      {:FourWkGrowth => {"$gt" => 0}},
      {:DailyMovement => {"$gt" => 0}},
      {:Official => true}
      ]}

    return @repo.find_by_query(query).to_a
  end
end
