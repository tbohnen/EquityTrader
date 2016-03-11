class QueryBase

  def initialize
    @con = Mongo::Connection.new
    @equities = @con[configatron.dbname]['Equity']
  end


end
