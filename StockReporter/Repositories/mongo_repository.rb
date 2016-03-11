require_relative '../config/defaults'
require 'mongo'

class MongoRepository

  def initialize(collection_name)
    Mongo::Logger.logger.level = ::Logger::FATAL
    client = Mongo::Client.new([configatron.dbserver],
                               :database => configatron.dbname
                               #:user => configatron.dbuser,
                               #:password => configatron.dbpassword
                              )
    @collection = client[collection_name]
  end

  def insert(data)
    return @collection.insert_one(data)
  end

  def find_by_query(query, options = {})
    return @collection.find(query)
  end

  def remove_by_query(query)
    return @collection.find(query).delete_many
  end

end
