require 'ostruct'
require_relative 'cached_report_generator'
require_relative 'my_stocks_report'

class MyStocksSummaryReport

  def initialize()
      @my_stocks_report = MyStocksReport.new
  end

  def generate(date, user_id)

    my_stocks_result = @my_stocks_report.generate(date, user_id)

    return [] if my_stocks_result.first.nil?

    rows = Array.new
    data = OpenStruct.new

    daily_movement = my_stocks_result.map{|r| r.DailyMovement.to_f }
    total_movement = my_stocks_result.map{|r| r.TotalMovement.to_f }
    close_prices = my_stocks_result.map{|r| r.ClosePrice.to_f}
    shares_value = my_stocks_result.map{|r| r.ClosePrice.to_f * r.NoOfShares.to_f}
    last_update = my_stocks_result.first.DateOfPrice

    portfolioUnitPrice = close_prices.reduce(:+).round(2)
    portfolioOverallValue = shares_value.reduce(:+).round(2)

    average_daily_movement = daily_movement.instance_eval { reduce(:+) / size.to_f }.round(2)
    average_total_movement = total_movement.instance_eval { reduce(:+) / size.to_f }.round(2)

    max_total_growth_share = my_stocks_result.max{|a,b| a.TotalMovement <=> b.TotalMovement}
    min_total_growth_share = my_stocks_result.min{|a,b| a.TotalMovement <=> b.TotalMovement}

    strongest_daily_share = my_stocks_result.max{|a,b| a.DailyMovement <=> b.DailyMovement}
    weakest_daily_share = my_stocks_result.min{|a,b| a.DailyMovement <=> b.DailyMovement}

    data.Date = last_update
    data.DailyAverage = average_daily_movement
    data.TotalMovement = average_total_movement


    data.StrongestShareOverall = create_summary_share_hash max_total_growth_share
    data.WeakestShareOverall = create_summary_share_hash min_total_growth_share
    data.StrongestDailyShare = create_summary_share_hash strongest_daily_share
    data.WeakestDailyShare = create_summary_share_hash weakest_daily_share

    data.PortfolioUnitPrice = portfolioUnitPrice
    data.PortfolioOverallValue  = portfolioOverallValue

    rows << data

    return rows

  end

  def create_summary_share_hash(share)
  {
   "ShareIndex" => share.ShareIndex,
   "TotalMovement" => share.TotalMovement,
   "DailyMovement" => share.DailyMovement
  }

  end


end

