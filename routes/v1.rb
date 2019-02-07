class App
  require 'rest-client'

  route 'v1' do |r|
    r.on 'welcome' do
      # check that there is a (valid) api key and rate limit hasn't been exceeded
      api_key = r.params['api_key']
      if api_key != ""
        if ValidateApiKey.new(api_key).api_key_valid?
          if RateLimiting.new.rate_limit_not_exceeded?(api_key)
            # begin routes
            r.get 'flights' do
              request = LufthansaApiCalls.new(r.params).validate_request_params
              request[:error] ? r.halt(400, errors: request[:messages]) : LufthansaApiCalls.new(r.params).get_flights
            end

            r.get 'destinations' do
              p("I selected #{ r.params['airport'] }")
              #get all selected airport destinations
              Airports.new(r.params['airport']).get_airport_destinations

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
