require_relative 'daily_stocks_report'

class DailyTopFortyReport 

  def initialize
    @daily_stocks_report = DailyStocksReport.new
  end

  def header
    @daily_stocks_report.new
  end

  def generate(date)
    rows = @daily_stocks_report.generate(date) 

    top_forty = rows
      .sort { |a, b| b.MarketCap <=> a.MarketCap}
      .take(40)

    return top_forty
  end

end
