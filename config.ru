dev = ENV['RACK_ENV'] == 'development'

if dev
  require 'logger'
  logger = Logger.new($stdout)
end

require 'rack/unreloader'
Unreloader = Rack::Unreloader.new(subclasses: %w'Roda Sequel::Model', logger: logger, reload: dev){App}
require_relative 'models'
Unreloader.require('app.rb'){'App'}
run(dev ? Unreloader : App.freeze.app)

require 'mail'
# defaults to deliver email with API key
Mail.defaults do
  delivery_method :smtp,
  {
    address: "smtp.gmail.com",
    port: 587,
    domain: ENV['GMAIL_DOMAIN'],
    user_name: ENV['GMAIL_USERNAME'],
    password: ENV['GMAIL_PASSWORD'],
    authentication: 'plain',
    enable_starttls_auto: true
  }
end
