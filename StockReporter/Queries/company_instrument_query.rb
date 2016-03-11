require 'mongo'
require_relative '../config/defaults'
require_relative '../Repositories/mongo_repository'

class CompanyInstrumentQuery

  def initialize
    @repo = MongoRepository.new('Company')
  end

  def find_one(share_index)
    return @repo.find_by_query({ "ShareIndex" => share_index }).first
  end

end
