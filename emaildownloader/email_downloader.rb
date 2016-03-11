require 'mail'
require_relative 'config'

Mail.defaults do
  retriever_method :pop3, :address => configatron.mail_server,
                   :port => 110,
                   :user_name => configatron.user_name,
                   :password => configatron.password
end

class Downloader
  def self.download_all_attachments()
        Mail.all.each{ |mail|
          if mail.subject.include?("InvestorData") || mail.subject.include?("ab")
            puts "Downloading: #{mail.subject}"
            mail.attachments.each do | attachment |
              if (attachment.content_type.start_with?('application/zip') || attachment.content_type.start_with?('application/octet-stream'))
                filename = attachment.filename
                if !File.exist?(configatron.processed_path + filename)
                  puts "copying: #{filename}"
                  File.open(configatron.download_path + filename, "w+b", 0644) {
                    |f| f.write attachment.body.decoded }
                else
                  puts "File Already exists #{filename}, skipping"
                end
              end
            end
          end

        }
      end
end
