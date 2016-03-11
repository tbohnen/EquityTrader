require 'configatron'

configatron.dbname = "stockanalyzer-demo"
configatron.mail_server = "mail.codeitright.co.za"
configatron.mail_port = 25
configatron.mail_domain = "no-reply-stocks@codeitright.co.za"
configatron.mail_from = "no-reply-stocks@codeitright.co.za"
configatron.mail_username = "no-reply-stocks@codeitright.co.za"
configatron.mail_password = 'P@ssw0rd'
configatron.mail_authentication = 'plain'

configatron.ignore_cache = false

configatron.get_latest_command = "mono ~/Source/stockanalyzer/GoogleFinanceHistoricalPriceRetriever/GoogleFinanceHistoricalPrice.Console/bin/Debug/GoogleFinanceHistoricalPrice.Console.exe demo"

configatron.refresh_technical_indicators = "mono ~/Source/stockanalyzer/TechnicalAnalyticsCalculators/TechnicalAnalysisCalculators.Console/bin/Debug/TechnicalAnalysisCalculators.Console.exe"
