class App
  require 'rest-client'

  route 'v1' do |r|
    r.on 'welcome' do
      api_key = r.params['api_key']
      if api_key != "" # check that there is an api key included
        if ValidateApiKey.new(api_key).api_key_valid?
          if RateLimiting.new.rate_limit_not_exceeded?(api_key)
      # move api key check + rate limit here
            r.get 'flights' do
              #validate request params
              valid_params = LufthansaApiCalls.new(r.params).request_params_valid?
              #response = LufthansaApiCalls.new(r.params).get_flights
              #add error handling
            end

            r.get 'airport' do
              p("I selected #{ r.params['airport'] }")
            end

          else
            r.halt(429, message: ErrorMessages::LIMIT_EXCEEDED)
          end
        else
          r.halt(401, message: ErrorMessages::API_KEY_INVALID)
        end
      else
        r.halt(400, message: ErrorMessages::QUERY_INVALID)
      end
    end
  end
end
