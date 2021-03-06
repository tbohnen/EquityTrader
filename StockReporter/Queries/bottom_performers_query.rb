require_relative '../Repositories/mongo_repository'
require_relative 'get_equities_by_type_for_date'

class BottomPerformersQuery

  def initialize
    @repo = MongoRepository.new("TechnicalIndicator")
    @company_repository = MongoRepository.new("Company")
  end

  def query(params)
    date = params[:date]

    start_date = Time.utc(date.year, date.month, date.day, 0, 0)
    end_date = Time.utc(date.year, date.month, date.day, 23, 59)

    share_indexes = @company_repository
      .find_by_query({:Type => "Equity"})
      .map{ |s| s[:ShareIndex] }


    @repo.find_by_query(
       :$and => [
         {:ShareIndex => {'$in' => share_indexes}},
         {:Date => {"$gte" => start_date}},
         {:Date => {"$lte" => end_date}},
         {:Official => true}
       ])
    .sort(:DailyMovement => 1)

  end

end
