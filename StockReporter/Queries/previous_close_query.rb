require_relative 'query_base'
require 'business_time'
require_relative '../Queries/equity_queries'

class PreviousClosePriceQuery < QueryBase
  def query(share_index, date)

    start_date = 1.business_days.before(Time.utc(date.year, date.month, date.day, 0, 0))
    end_date = 1.business_days.before(Time.utc(date.year, date.month, date.day, 23, 59))

    return @equities.find_one({ :$and =>
      [
        {:ShareIndex => share_index},
        {:DateOfPrice => {:$gte => start_date}},
        {:DateOfPrice => {:$lte => end_date}},
        {:Latest => true}
      ]})["ClosePrice"].to_f
  end
end
