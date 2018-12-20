class App
  require './lib/gettoken.rb'
  require './lib/validateapikey.rb'
  require './lib/ratelimiting.rb'
  require 'rest-client'

  route 'v1' do |r|
    r.on 'welcome' do
      r.get 'flights' do
        api_key = r.params['api_key']
        if api_key
          if ValidateApiKey.new(api_key).api_key_valid?
            if RateLimiting.new.rate_limit_not_exceeded?(api_key)
              lh_token = GetToken.new.obtain_lh_token
              # API call needs to be separated into its own class
              auth = "#{lh_token['token_type'].capitalize} #{lh_token['access_token']}" # format: "Bearer kfu894usdbj"
              url = 'https://api.lufthansa.com/v1/operations/schedules/FRA/SFO/2019-02-24?directFlights=1' # hardcoded params for now
              RestClient::Request.execute(
                method: :get,
                url: url,
                headers: { Authorization: auth, Accept: 'application/json' }
                ) { |response|
                  case response.code
                  when 200
                    response
                  when 400
                    r.halt(400, { status: 400, error: 'Bad request', message: 'Please check your parameters' })
                  else
                    r.halt(400, { status: 400, error: 'Bad request', message: 'Something went wrong' })
                  end
                }
            else
              r.halt(429, { status: 429, error: 'Too many requests', message: 'You have exceeded your daily request limit' })
            end
          else
            r.halt(401, { status: 401, error: 'Unauthorized', message: 'Api key is invalid' })
          end
        else
          r.halt(400, { status: 400, error: 'Bad request', message: 'No api key present' })
        end
      end
    end
  end
end
