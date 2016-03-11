require 'configatron'

if ENV["RUBY_ENV"] == "prod"
  configatron.mail_server = ""
  configatron.user_name =  ""
  configatron.password = ""
  configatron.processed_path = ""
  configatron.download_path = ""
else
  configatron.mail_server = ""
  configatron.user_name =  ""
  configatron.password = ""
  configatron.download_path = ""
  configatron.processed_path = ""
end

