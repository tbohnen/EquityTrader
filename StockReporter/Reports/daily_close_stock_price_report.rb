require_relative '../Queries/movement_between_dates_query'
require 'ostruct'

class DailyCloseStockPriceReport

  def initialize
    @movement_between_dates_query = MovementBetweenDatesQuery.new
  end

  def generate(params)
    share_index, start_date, end_date = params[:shareindex], Time.parse(params[:startdate]), Time.parse(params[:enddate])

    equity_results = @movement_between_dates_query.query(share_index, start_date, end_date)

    rows = Array.new
    equity_results.each{|e|
      row = OpenStruct.new
      #TODO: Would this not be better to see if there is a way to change a array to openstruct? I.e. OpenStruct.new(hash)
      #row.openPrice = e["OpenPrice"].to_f.round(2)
      row.highPrice = e["HighPrice"].to_f.round(2)
      row.lowPrice = e["LowPrice"].to_f.round(2)
      row.closePrice = e["ClosePrice"].to_f.round(2)
      row.volume = e["Volume"].to_f.round(2)
      row.dateOfPrice = e["DateOfPrice"]
      rows << row
    }
    return rows

  end

end
