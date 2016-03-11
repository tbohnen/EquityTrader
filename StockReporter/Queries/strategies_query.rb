class StrategiesQuery
  def initialize
    @repo = MongoRepository.new('Strategies')
  end

  def query(key)
    @repo.find_by_query({"key" => key}).to_a
  end
end
