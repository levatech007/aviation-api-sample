require_relative 'models'

require 'roda'
require 'sequel'

class App < Roda
  # Don't delete session secret from environment in development mode as it breaks reloading
  session_secret = ENV['RACK_ENV'] == 'development' ? ENV['APP_SESSION_SECRET'] : ENV.delete('APP_SESSION_SECRET')

  plugin :multi_route
  plugin :json
  plugin :halt
  # require all files from  /lib directory
  Dir['./lib/*.rb'].each {|file| require file }
  # require documentation
  file = File.read('documentation.json')
  documentation = JSON.parse(file)

  Unreloader.require('routes') {}

  route do |r|
    r.on 'api' do
      r.multi_route
    end

    r.root do
      documentation
    end

  end
end
