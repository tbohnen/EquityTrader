require 'mail'
require_relative 'config/defaults'

class MailSender

  def initialize
  end

  def self.send_mail_with_attachment(email_addresses, body,subject, file)
    options = {
      :address              => configatron.mail_server,
      :port                 => configatron.mail_port,
      :domain               => configatron.mail_domain,
      :user_name            => configatron.mail_username,
      :password             => configatron.mail_password,
      :authentication       => configatron.mail_authentication,
      :enable_starttls_auto => false  }

    Mail.defaults do
      delivery_method :smtp, options
    end

    Mail.deliver do
      to email_addresses
      from configatron.mail_from
      subject subject
      body "#{body}"
      add_file file
    end
  end

  def self.send_mail(email_addresses, body, subject)
    options = {
      :address              => configatron.mail_server,
      :port                 => configatron.mail_port,
      :domain               => configatron.mail_domain,
      :user_name            => configatron.mail_username,
      :password             => configatron.mail_password,
      :authentication       => configatron.mail_authentication,
      :enable_starttls_auto => false  }

    Mail.defaults do
      delivery_method :smtp, options
    end

    Mail.deliver do
      to email_addresses
      from configatron.mail_from
      subject subject
      body "#{body}"
    end

  end
end
