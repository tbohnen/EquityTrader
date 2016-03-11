require_relative '../Repositories/mongo_repository'

class DayMovementQuery

  def initialize
    @repo = MongoRepository.new('Equity')
  end

  def query(equities, date)

    start_date = Time.utc(date.year, date.month, date.day, 0, 0)
    end_date = Time.utc(date.year, date.month, date.day, 23, 59)

    results =  @repo.find_by_query(:$and =>
                              [
                                {:ShareIndex => {:$in => equities}},
                                {:DateOfPrice => {"$gte" => start_date}},
                                {:DateOfPrice => {"$lte" => end_date}},
                                {:Latest => true}
                              ])
                                .select{|e| e["ClosePrice"].to_f != 0 }
                                .to_a

                              return results
  end

end
