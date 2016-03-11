require_relative 'Reports/daily_stocks_report'
require_relative 'Reports/sector_best_report'
require_relative 'Reports/my_stocks_report'
require_relative 'Reports/cached_report_generator'
require_relative 'notifications/notification'
require_relative 'Queries/all_users_query'

class CachedReportsGenerator

  def initialize
    @all_users_query = AllUsersQuery.new

  end

  def regenerate_all_reports(*args)

    date = args[0]
    
    @all_users_query.query().each{|u| 
      generate_my_stocks_report(date, u["_id"])
      generate_my_stocks_summary_report(date, u["_id"])
    }

    generate_stocks_with_highest_one_year_growth(date)
  end

  private

  def generate_my_stocks_report(date, user_id)
    my_stocks_report = MyStocksReport.new
    cached_report_generator = CachedReportGenerator.new(my_stocks_report)

    #cached_report_generator.remove_cached_report(date,user_id)
    cached_report_generator.regenerate(date, user_id)
  end

  def generate_stocks_with_highest_one_year_growth(date)
    daily_stocks_report = DailyStocksReport.new
    cached_report_generator = CachedReportGenerator.new(daily_stocks_report)
    
    #cached_report_generator.remove_cached_report(date)
    cached_report_generator.regenerate(date)
  end

  def generate_my_stocks_summary_report(date, user_id)
    my_stocks_summary_report = MyStocksSummaryReport.new
    cached_report_generator = CachedReportGenerator.new(my_stocks_summary_report)

    #cached_report_generator.remove_cached_report(date, user_id)
    cached_report_generator.regenerate(date, user_id)
  end

end
