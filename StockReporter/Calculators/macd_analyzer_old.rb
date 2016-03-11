require_relative '../Queries/equity_queries'
require 'date'
require 'business_time'

class MacdAnalyzer

  def initialize
    
    @equity_queries = EquityQueries.new

  end

  def ema_for_period(share_index, number_of_days, date)
      previous_average_array = @equity_queries.get_previous_prices(date, number_of_days, share_index)

      return -1 if previous_average_array.count < number_of_days 

      today_price = @equity_queries.get_close_price(share_index, date)

      return -1 if today_price.nil?

      return calc_macd(number_of_days,previous_average_array, today_price)

  end


  def calc_macd(number_of_days, previous_prices, close_price)

      k = get_k(number_of_days)
      average = previous_prices.inject(:+) / number_of_days

      price_with_k = close_price * k
      previous_with_k = average * (1- k)

      return price_with_k + previous_with_k

  end

  def get_k(number_of_days)
     2 / (number_of_days + 1) 
  end

  def macd_line(share_index, date)
    ema_12 = ema_for_period(share_index, 12, date)
    ema_26 = ema_for_period(share_index, 26, date)

    return ema_12 - ema_26
  end

  def signal_line(share_index, date)
    days_back_9 = subtract_days_return_time(date,9)
    days_back_8 = subtract_days_return_time(date,8)
    days_back_7 = subtract_days_return_time(date,7)
    days_back_6 = subtract_days_return_time(date,6)
    days_back_5 = subtract_days_return_time(date,5)
    days_back_4 = subtract_days_return_time(date,4)
    days_back_3 = subtract_days_return_time(date,3)
    days_back_2 = subtract_days_return_time(date,2)
    days_back_1 = subtract_days_return_time(date,1)
    days_back_0 = subtract_days_return_time(date,0)
    
    macd_9 = macd_line(share_index, days_back_9)
    macd_8 = macd_line(share_index, days_back_8)
    macd_7 = macd_line(share_index, days_back_7)
    macd_6 = macd_line(share_index, days_back_6)
    macd_5 = macd_line(share_index, days_back_5)
    macd_4 = macd_line(share_index, days_back_4)
    macd_3 = macd_line(share_index, days_back_3)
    macd_2 = macd_line(share_index, days_back_2)
    macd_1 = macd_line(share_index, days_back_1)
    macd_0 = macd_line(share_index, days_back_0)

    prices = [macd_9, macd_8, macd_7, macd_6, macd_5, macd_4, macd_3, macd_2, macd_1]

    return calc_macd(9, prices, macd_0)
  end

  def subtract_days_return_time(time, days_to_subtract)
    return days_to_subtract.business_days.before(time)
  end

end
