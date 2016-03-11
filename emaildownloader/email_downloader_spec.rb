require 'rspec'
require_relative 'email_downloader'

describe "something" do
  it "will read and show mails" do
    Downloader.download_all_attachments
    File.exist?('Path to downloaded file')
  end
end
