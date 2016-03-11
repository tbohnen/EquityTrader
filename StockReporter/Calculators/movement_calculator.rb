require 'business_time'
require_relative '../Queries/equity_queries'

class MovementCalculator
  
  def initialize
    @equity_queries = EquityQueries.new
  end
  
  def movement_between_weeks(share_index, latest_day, weeks)
    days_before = weeks * 5
    oldest_day = days_before.business_days.before(latest_day)

    latest_close_price = @equity_queries.get_close_price(share_index, latest_day)
    oldest_close_price = @equity_queries.get_close_price(share_index, oldest_day)

    return -1 if latest_close_price.nil? || oldest_close_price.nil? || latest_close_price == 0 || oldest_close_price == 0

    return calculate_difference(latest_close_price, oldest_close_price)
  end

  def movement_between_days(share_index, latest_day, oldest_day)
    latest_close_price = @equity_queries.get_close_price(share_index, latest_day)
    oldest_close_price = @equity_queries.get_close_price(share_index, oldest_day)

    return -1 if latest_close_price.nil? || oldest_close_price.nil? || latest_close_price == 0 || oldest_close_price == 0

    return calculate_difference(latest_close_price, oldest_close_price)
  end

  def business_day_movement(share_index, date)
    previous_business_date = 1.business_days.before(date)

    current_day_price = @equity_queries.get_close_price(share_index, date)
    previous_day_price = @equity_queries.get_close_price(share_index, previous_business_date)

    return -1 if current_day_price.nil? || previous_day_price.nil? || current_day_price == 0 || previous_day_price == 0
    return calculate_difference(current_day_price, previous_day_price)
  end

  private

  def calculate_difference(latest_price, oldest_price)
    return (((latest_price / oldest_price) - 1) * 100).round(2)
  end
end
