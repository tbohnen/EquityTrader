class WatchlistQuery

  def initialize
    @con = Mongo::Connection.new
    @my_watchlist = @con[configatron.dbname]['MyWatchlist']

  end

  def query(user_id)
    watchlists = @my_watchlist.find({"UserId" => BSON::ObjectId("5550df013b84fe28a0000001")})
    return watchlists
  end
end
