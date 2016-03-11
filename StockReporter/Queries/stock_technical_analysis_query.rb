require_relative '../Repositories/mongo_repository'

class StockTechnicalAnalysisQuery
  def initialize
    @repo = MongoRepository.new('TechnicalIndicator')
  end

  def query(share_index, date)

    start_date = Time.utc(date.year, date.month, date.day, 0, 0, 0)
    end_date = Time.utc(date.year, date.month, date.day, 23, 59, 59)


    results = @repo.find_by_query(:$and => 
                              [
                                {:ShareIndex => share_index}, 
                                {:Date => {"$gte" => start_date}},
                                {:Date => {"$lte" => end_date}}
                              ])
    results.first
  end
end
