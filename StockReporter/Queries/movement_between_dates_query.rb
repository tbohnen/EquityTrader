require_relative '../config/defaults'
require 'configatron'
require 'mongo'

class MovementBetweenDatesQuery

  def initialize
    @repo = MongoRepository.new('Equity')
  end

  def query(share_index, start_date, end_date)

    query_results =  @repo.find_by_query(:$and =>
                              [
                                {:ShareIndex => share_index}, 
                                {:DateOfPrice => {"$gte" => start_date}},
                                {:DateOfPrice => {"$lte" => end_date}},
                                {:Latest => true}
                              ])

    return query_results.to_a
    #return query_results.to_a.sort{|x| x[:DateOfPrice]}
  end
end
