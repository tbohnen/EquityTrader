require 'ostruct'
require 'business_time'
require_relative '../Calculators/rsi_calculator'
require_relative '../Queries/equity_queries'

class Float
  def to_locale_s
    return self.to_s.tr!('.', ',')
  end
end

class RsiReport

  def header
    return ["close_price", "date", "rsi"]
  end

  def generate(params)
    share_index = params[:shareindex]
    start_date = Time.parse(params[:startdate])
    end_date = Time.parse(params[:enddate])

    rsi_calculator = RsiCalculator.new
    equity_queries = EquityQueries.new
    rows = Array.new

    current_date = start_date

    previous_prices = equity_queries.get_previous_prices(current_date, 200, share_index)

    s = Date.parse(start_date.to_s)
    e = Date.parse(end_date.to_s)

    days = s.business_days_until(e) + 1

    start = previous_prices.count - days

    result = rsi_calculator.calculate(previous_prices,start,days)

    count = 0

    while current_date <= end_date do
      row = OpenStruct.new
      row.close_price = equity_queries.get_close_price(share_index,current_date)
      row.date = current_date.strftime("%Y-%m-%d")
      row.rsi = result[count].to_locale_s
      rows.push(row)
      count = count + 1
      current_date = 1.business_days.after(current_date)
    end
    return rows

  end
end

