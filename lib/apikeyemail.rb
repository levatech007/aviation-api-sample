class ApiKeyEmail
  require 'mail'

  def initialize(email, key)
    @email = email
    @api_key = key
  end

  def send_email
    to = @email #Mail.new does not recognize @email, workaround
    html_template = ERB.new(File.read('views/api_key_email.html.erb')).result(binding)
    #text_template = ERB.new(File.read('views/api_key_email.text.erb')).result(binding)
    mail = Mail.new do
      from ENV['GMAIL_USERNAME']
      to to
      subject "Your API key"
    end
    text_part = Mail::Part.new do
      body "Your API key is: #{ @api_key }"
    end
    html_part = Mail::Part.new do
      content_type 'text/html; charset=UTF-8'
      body html_template
    end

    mail.text_part = text_part
    mail.html_part = html_part
    mail.deliver
  end

end
