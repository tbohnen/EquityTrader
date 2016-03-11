require 'gcm'
require_relative '../Queries/all_devices_query'

class Notification

  def initialize
    all_devices_query = AllDevicesQuery.new

    @registration_ids = all_devices_query.query().map{|x| x["Id"]}.to_a
    @project_id = ""

  end

  def send_notification(message)
    gcm = GCM.new(@project_id)

    options = {data: {status:"ok",message:message,msgcnt:2}}

    response = gcm.send(@registration_ids, options)

    puts response

    return response
  end
end
