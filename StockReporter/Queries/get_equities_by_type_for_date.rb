require_relative '../Repositories/mongo_repository'

class GetEquitiesByTypeForDate

  def initialize
    @company_repository = MongoRepository.new("Company")
    @equity_repository = MongoRepository.new("Equity")
  end

  def query(params)
    date = params[:date]
    type = params[:type]

    start_date = Time.utc(date.year, date.month, date.day, 0, 0)
    end_date = Time.utc(date.year, date.month, date.day, 23, 59)

    share_indexes = @company_repository
      .find_by_query({:Type => type})
      .map{ |s| s[:ShareIndex] }

     @equity_repository.find_by_query(
       :$and => [
         {:ShareIndex => {:$in => share_indexes}},
         {:DateOfPrice => {"$gte" => start_date}},
         {:DateOfPrice => {"$lte" => end_date}},
         {:Latest => true}
       ])

  end

end
