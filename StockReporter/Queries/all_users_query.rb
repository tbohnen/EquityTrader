require 'mongo'
require_relative '../config/defaults'
require_relative '../Repositories/mongo_repository'

class AllUsersQuery

  def initialize
    @users = MongoRepository.new("Users")
  end

  def query()
    return @users.find_by_query({}).to_a
  end

end
