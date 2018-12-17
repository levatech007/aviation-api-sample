class App
  require './lib/gettoken.rb'
  require './lib/validateapikey.rb'
  require './lib/ratelimiting.rb'
  require 'rest-client'

  route 'v1' do |r|
    r.on 'welcome' do
      r.get "flights" do
        key = r.params['api_key']
        if key
          if ValidateApiKey.new(key).api_key_valid?()
            if RateLimiting.new.rate_limit_not_exceeded?(key)
              lh_token = GetToken.new.get_lh_token()
              auth = "#{ lh_token['token_type'].capitalize } #{ lh_token['access_token'] }" #format: "Bearer kfu894usdbj"
              url = "https://api.lufthansa.com/v1/operations/schedules/FRA/SFO/2018-12-25?directFlights=1" #hardcoded params for now
              response = RestClient::Request.execute(
              method: :get,
              url: url,
              headers: { Authorization: auth, Accept: "application/json" }
              ) { |response, request, result|
                case response.code
                when 200
                  response
                when 400
                  r.halt(400, { status: 400, error: "Bad request", message: "Please check your parameters"})
                else
                  r.halt(400, { status: 400, error: "Bad request", message: "Something went wrong"})
                end
              }

            else
              r.halt(429, { status: 429, error: "Too many requests", message: "You have exceeded your daily request limit" })
            end
          else
            r.halt(401, { status: 401, error: "Unauthorized", message: "Api key is invalid"})
          end
        else
          r.halt(400, { status: 400, error: "Bad request", message: "No api key present"})
        end
      end
    end
  end
end
