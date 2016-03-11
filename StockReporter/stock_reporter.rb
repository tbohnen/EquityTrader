require_relative 'email_stock_reporter'

stock_reporter = EmailStockReporter.new

# for now the arguments need to be passed in specific order if required: Date followed by email addresses

utcnow = Time.utc(Time.now.year, Time.now.month,Time.now.day)
emails = Array.new << "youremail@email.com"

if !ARGV[0].nil? 
  utcnow = Time.parse(ARGV[0])
  utcnow = Time.utc(utcnow.year, utcnow.month, utcnow.day)
end

if !ARGV[1].nil?
  emails = ARGV[1]
end

puts "date #{utcnow}"

stock_reporter.send_my_stocks_report(utcnow, emails)
stock_reporter.send_stocks_with_highest_one_year_growth(utcnow, emails)
stock_reporter.send_sector_best(utcnow, emails)
