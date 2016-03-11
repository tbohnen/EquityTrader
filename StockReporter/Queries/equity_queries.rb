require 'mongo'
require 'business_time'
require_relative '../config/defaults'

class EquityQueries

  @@client = nil

  def initialize

    if @@client.nil?
      @@client = Mongo::Client.new([configatron.dbserver],
                               :database => configatron.dbname
                               #:user => configatron.dbuser,
                               #:password => configatron.dbpassword
                                  )
    end

    @equities = @@client['Equity']
    @my_equities = @@client['MyEquities']

  end

  def get_my_shares(user_id)
    rows = @my_equities.find({:UserId => user_id})
    return rows
  end

  def get_highest_52wkGrowth(date)
    start_date = Time.utc(date.year, date.month, date.day, 0, 0)
    end_date = Time.utc(date.year, date.month, date.day, 23, 59)

    return @equities.find( :$and => 
      [ {:DateOfPrice => {"$gte" => start_date}}, 
        {:DateOfPrice => {"$lte" => end_date}},
        {:Sector => { "$ne" => "ALTX (ALTX)"}},
        {:Latest => true}
      ]).to_a
      .sort { |a, b| 
              [b["FiftyTwoWkGrowth"].to_f, b["SixMonthGrowth"].to_f, b["FourWkGrowth"].to_f] <=>
              [a["FiftyTwoWkGrowth"].to_f,
              a["SixMonthGrowth"].to_f,
              a["FourWkGrowth"].to_f]}
  end

  
  def get_previous_prices(date, number_of_days, share_index)

    start_date = (number_of_days+1).business_days.before(date)

    prices =  @equities.find({ :$and => [
      {:DateOfPrice => {"$gte" => start_date}},
      {:DateOfPrice => {"$lt" => date}},
      {:ShareIndex => share_index},
      {:Latest => true}
    ] },
    {:limit => number_of_days, :sort => { :DateRetrieved => :desc} })
      .take(number_of_days)
      .to_a
      .map {|share| share["ClosePrice"].to_f}

    return prices
  end

  def get_share(share_index,date)
    start_date = Time.utc(date.year, date.month, date.day, 0, 0)
    end_date = Time.utc(date.year, date.month, date.day, 23, 59)

    return @equities.find({ :$and => 
      [
        {:ShareIndex => share_index},
        {:DateOfPrice => {:$gte => start_date}},
        {:DateOfPrice => {:$lte => end_date}},
        {:Latest => true}
      ]}).first
  end

  def get_close_price(share_index,date)
    close_price = get_share(share_index,date)
    return nil if close_price.nil?
    return close_price["ClosePrice"].to_f
  end
end
