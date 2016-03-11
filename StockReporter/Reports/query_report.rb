require_relative '../Queries/fifty_two_to_daily_momentum_stocks_query'

class QueryReport

  def initialize()
  end

  def generate(params)
    query = params["query"]
    eval(query).new.query(params)
  end
end
