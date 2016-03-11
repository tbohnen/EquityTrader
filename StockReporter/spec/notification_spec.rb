require 'rspec'
require_relative '../notifications/notification'

describe Notification do

  it "Should send a notification message to GCM" do
    notifications = Notification.new

    response = notifications.send_notification("test message")

    expect(response[:status_code]).to eq 200
  end

end
