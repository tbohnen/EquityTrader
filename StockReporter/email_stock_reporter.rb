require_relative 'mail_sender'
require_relative 'Reports/daily_stocks_report'
require_relative 'Reports/sector_best_report'
require_relative 'Reports/my_stocks_report'
require_relative 'Reports/excel_report_generator'
require_relative 'Reports/cached_report_generator'


class EmailStockReporter

  def send_my_stocks_report(date, emails)

    my_stocks_report = MyStocksReport.new
    cached_report_generator = CachedReportGenerator.new(my_stocks_report)

    cached_report_generator.remove_cached_report(date)

    report_generator = ExcelReportGenerator.new(cached_report_generator)
    file_name = "my_shares_#{date.strftime("%Y-%m-%d")}"

    report_generator.save_as(file_name,date)

    MailSender.send_mail_with_attachment(emails, "see attachment","Daily My Stocks Report", file_name + ".xls")
  end

  def send_stocks_with_highest_one_year_growth(date, emails)
    daily_stocks_report = DailyStocksReport.new
    cached_report_generator = CachedReportGenerator.new(daily_stocks_report )
    
    cached_report_generator.remove_cached_report(date)

    report_generator = ExcelReportGenerator.new(cached_report_generator)
    file_name = "all_daily_shares_#{date.strftime("%Y-%m-%d")}"

    report_generator.save_as(file_name,date)

    MailSender.send_mail_with_attachment(emails, "see attachment","Daily All Shares Report", file_name + ".xls")
  end

  def send_sector_best(date, emails)
    sector_best_report = SectorBestReport.new
    cached_report_generator = CachedReportGenerator.new(sector_best_report )

    cached_report_generator.remove_cached_report(date)

    report_generator = ExcelReportGenerator.new(cached_report_generator)
    file_name = "sector_best_#{date.strftime("%Y-%m-%d")}"

    report_generator.save_as(file_name,date)

    MailSender.send_mail_with_attachment(emails, "see attachment","Daily Sector best report", file_name + ".xls")
  end

end
