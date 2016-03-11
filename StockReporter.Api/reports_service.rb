require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'business_time'

require_relative '../StockReporter/config/defaults'
require_relative '../StockReporter/Repositories/mongo_repository'
require_relative '../StockReporter/cached_reports_generator'

#I am over making this work for a folder, doing it one by one
require_relative '../StockReporter/Reports/daily_close_stock_price_report'
require_relative '../StockReporter/Reports/daily_stocks_report'
require_relative '../StockReporter/Reports/query_report'
require_relative '../StockReporter/Reports/my_portfolio_report'
require_relative '../StockReporter/Reports/my_transaction_report'
require_relative '../StockReporter/Reports/sector_best_report'
require_relative '../StockReporter/Reports/my_stocks_summary_report'
require_relative '../StockReporter/Reports/my_stocks_report'
require_relative '../StockReporter/Reports/my_watchlist_report'
require_relative '../StockReporter/Reports/daily_top_performers_report'
require_relative '../StockReporter/Reports/daily_bottom_performers_report'
require_relative '../StockReporter/Reports/daily_top_forty_report'
require_relative '../StockReporter/Queries/latest_equity_date_query'

set :bind, '0.0.0.0'
set :port, 8080

before do

  headers 'Access-Control-Allow-Origin' => '*',
    'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST'],
    'Access-Control-Allow-Headers' => 'Content-Type'

   content_type :json
end


options '/latestDate' do
  200
end

get '/latestDate' do
  date = latest_equity_date

  return {"date" => date}.to_json
end

options '/chartReport' do
  200
end

get '/chartReport' do
  report_name = params["reportname"]
  report = eval(report_name).new

  report_generator = CachedReportGenerator.new(report)

  rows = report_generator.generate(params)

  if rows.count > 0 && rows[0].class.name != "BSON::OrderedHash" 
    rows = convert_openstructs_to_hash(rows)
  end

  puts "Returned Rows: #{rows.count}"

  json = {:Rows => rows}.to_json

  return json

end

options '/dashboard' do
  200
end

get '/dashboard' do
  return 200 if params[:userId].blank?

  user_id = BSON::ObjectId(params[:userId]) if 

  my_stocks_summary_report = MyStocksSummaryReport.new

  latest_date = latest_equity_date

  date = Time.utc(latest_date.year, latest_date.month, latest_date.day)
  rows = my_stocks_summary_report.generate(date,user_id)

  if rows.count > 0 && rows[0].class.name != "BSON::OrderedHash" 
    rows = convert_openstructs_to_hash(rows)
  end

  return {:Rows => rows}.to_json
end

options '/report/queryreport/:query' do
  200
end

get '/report/queryreport/:query' do
  report_params = params
  report_params.delete("captures")
  report_params.delete("splat")
  report_params["date"] = Time.parse(params[:date])

  report = QueryReport.new
  rows = report.generate(report_params)
  return {:Rows => rows}.to_json
end

options '/report/:reportname' do
  200
end

get '/report/:reportname' do
  report_name = params[:reportname]
  date = Time.parse(params[:date])
  user_id = BSON::ObjectId(params[:userId]) if !params[:userId].blank?
  cached = params[:cached]

  puts "Executing report:#{report_name} with date: #{date}"

  report = eval(report_name).new

  report_params = []
  report_params << Time.utc(date.year, date.month, date.day) if !date.nil?
  report_params << user_id if !user_id.nil?

  report_generator = report

  rows = report_generator.generate(*report_params)

  if rows.count > 0 && rows[0].class.name != "BSON::OrderedHash" 
    rows = convert_openstructs_to_hash(rows)
  end

  puts "Returned Rows: #{rows.count}"

  return {:Rows => rows}.to_json

end

get '/refresh' do

  Process.spawn(configatron.get_latest_command)
  Process.wait

  Process.spawn(configatron.refresh_technical_indicators)
  Process.wait

  cached_report_generator = CachedReportsGenerator.new

  date = Time.utc(Time.now.year, Time.now.month,Time.now.day); 
  cached_report_generator.regenerate_all_reports(date) 

  200
end

options '/deleteMySharesTransaction' do
  200
end

post '/deleteMySharesTransaction/:id' do
  id = BSON::ObjectId(params["id"])

  my_stocks_repo = MongoRepository.new("MyEquities")
  my_stocks_repo.remove_by_query({"_id" => id})

  200
end

options '/addWatchlistShare' do
  200
end

post '/addWatchlistShare' do
  watchlist_share = JSON.parse(request.body.read)

  watchlist_share["UserId"] = BSON::ObjectId(watchlist_share["UserId"])
  watchlist_share["DateAdded"] = Time.parse(watchlist_share["DateAdded"])

  repo = MongoRepository.new("MyWatchlist")
  repo.insert(watchlist_share)
  200
end

options '/deleteWatchlistShare' do
  200
end

post '/deleteWatchlistShare/:id' do
  id = BSON::ObjectId(params["id"])

  repo = MongoRepository.new("MyWatchlist")
  repo.remove_by_query({"_id" => id})

  200
end


options '/addMySharesTransaction' do
  200
end

post '/addMySharesTransaction' do
  share_transaction = JSON.parse(request.body.read)

  share_transaction["UserId"] = BSON::ObjectId(share_transaction["UserId"])
  share_transaction["DateOfPurchase"] = Time.parse(share_transaction["DateOfPurchase"])

  repo = MongoRepository.new("MyEquities")
  repo.insert(share_transaction)

  200
end

options '/addUser/:email' do
  200
end

post '/addUser/:email' do
  repo = MongoRepository.new("Users")
  all_users_query = AllUsersQuery.new

  email = params[:email]

  exists = all_users_query.query().any?{|u| u["Email"] == email}

  if !exists 
    repo.insert({:Email => email, :Params => params})
  end

  query = all_users_query.query()

  found_user_id = query.find{|u| u["Email"] == email}['_id']

  return {"id" => found_user_id.to_s}.to_json
end


get '/addDevice/:deviceId' do
  repo = MongoRepository.new("Devices")
  all_devices_query = AllDevicesQuery.new
  id = params[:deviceId]

  exists = all_devices_query.query().any?{|x| x["Id"] == id}

  if !exists 
    repo.insert({:Id => id})
  end
end

options '/strategy/industryBest' do
  200
end

get '/strategy/industryBest' do
  minimum_market_cap = params[:mimimumMarketCap]
  number_of_biggest_industries = params[:numberOfBiggestIndustries]
  number_of_top_performers = params[:numberOfTopPerformers]

  Process.spawn("node #{configatron.portfolio_strategy_file} #{minimum_market_cap} #{number_of_biggest_industries} #{number_of_top_performers}")
  Process.wait
  strategies_query = StrategiesQuery.new

  result = strategies_query.query("#{minimum_market_cap}#{number_of_biggest_industries}#{number_of_top_performers}")
  return result.to_json
end

def convert_openstructs_to_hash(rows)
  hash_rows = Array.new
  rows.each{|r| hash_rows.push(r.marshal_dump)}
  return hash_rows
end

def latest_equity_date
  return LatestEquityDateQuery.new.query
end


