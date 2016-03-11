require 'mongo'
require_relative '../config/defaults'

class AllDevicesQuery

  def initialize
    @repo = MongoRepository.new("Devices")
  end

  def query()
    @repo.find_by_query([]).to_a
  end

end
