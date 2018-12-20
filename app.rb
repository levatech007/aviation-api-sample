require_relative 'models'

require 'roda'

class App < Roda

  # Don't delete session secret from environment in development mode as it breaks reloading
  session_secret = ENV['RACK_ENV'] == 'development' ? ENV['APP_SESSION_SECRET'] : ENV.delete('APP_SESSION_SECRET')

  plugin :multi_route
  plugin :json
  plugin :halt

  Unreloader.require('routes'){}

  route do |r|
    r.on 'api' do
      r.multi_route
    end

    r.root do
      file = File.read('documentation.json')
      JSON.parse(file)
    end
  end
end
