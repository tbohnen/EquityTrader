require 'mongo'
require_relative 'my_stocks_summary_report'
require_relative 'cached_report_generator'
require 'business_time'
require 'time'

class MyPortfolioReport

  def generate(params)

    start_date = Time.parse(params[:startdate])
    end_date = Time.parse(params[:enddate])
    user_id = BSON::ObjectId(params[:userId])

    report = CachedReportGenerator.new(MyStocksSummaryReport.new)

    current_date = start_date
    rows = Array.new

    while current_date <= end_date
      if isNotWeekday(current_date)
        current_date = getNextBusinessDay(current_date)
        next
      end

      my_stocks_summary_row = report.generate(current_date, user_id).first

      if my_stocks_summary_row.nil?
        current_date = getNextBusinessDay(current_date)
        next
      end

      row = OpenStruct.new

      row.date = current_date
      row.dailyAverage = my_stocks_summary_row["DailyAverage"]
      row.totalMovement = my_stocks_summary_row["TotalMovement"]
      row.portfolioUnitPrice = my_stocks_summary_row["PortfolioUnitPrice"]
      row.portfolioOverallValue = my_stocks_summary_row["PortfolioOverallValue"]

      rows << row
      current_date = getNextBusinessDay(current_date)
    end

    return rows
  end

  private

  def getNextBusinessDay(current_date)
    next_day = add_days(current_date,1)
    while (next_day.wday == 0 || next_day.wday == 6)
      next_day = add_days(next_day,1)
    end

    return next_day
  end

  def isNotWeekday(time)
    #TODO:this should be possible on the time object as well but for some reason it's not...?
    return (time.wday == 0 && time.wday == 6)
    #return !Date.new(time.year, time.month, time.day).weekday?

  end

def add_days(time, n_days)
  t2 = time + (n_days * 86400)
  utc_delta = time.utc_offset - t2.utc_offset
  (utc_delta == 0) ? t2 : t2 + utc_delta
  return t2
end

end
