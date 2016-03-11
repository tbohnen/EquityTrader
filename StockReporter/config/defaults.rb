require 'configatron'

environment = ENV['RACK_ENV']
puts "Environment: #{environment}"

configatron.dbserver = "localhost"

if environment == "test"
  configatron.dbname = "stockanalyzer_test"
else
  configatron.dbname = "stockanalyzer"
end

configatron.dbuser = ""
configatron.dbpassword = ""

configatron.mail_server = ""
configatron.mail_port = 25
configatron.mail_domain = ""
configatron.mail_from = ""
configatron.mail_username = ""
configatron.mail_password = ''
configatron.mail_authentication = 'plain'

configatron.portfolio_strategy_file = "./portfoliostrategies/index.js";

configatron.ignore_cache = true

configatron.get_latest_command = "Path to some app"

configatron.refresh_technical_indicators = "path to some app"
