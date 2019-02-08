# sends newly generated API key to user provided email
class SendApiKeyEmail
  require 'mail'

  def initialize(email, key)
    @email   = email
    @api_key = key
  end

  def send_email
    to_email      = @email # Mail.new does not recognize instance variables
    html_template = ERB.new(File.read('views/api_key_email.html.erb')).result(binding)
    # also add in text_template + text_part
    mail = Mail.new do
      from ENV['GMAIL_USERNAME']
      to to_email
      subject 'Your API key'
    end

    html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body html_template
    end

    mail.html_part = html_part
    mail.deliver
  end
end
