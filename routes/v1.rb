class App
  require 'rest-client'

  route 'v1' do |r|
    r.on 'welcome' do
      # check that there is a (valid) api key and rate limit hasn't been exceeded before proceeding to routes
      api_key = r.params['api_key']
      if api_key != ""
        if ValidateApiKey.new(api_key).api_key_valid?
          if RateLimiting.new.rate_limit_not_exceeded?(api_key)
            # begin routes
            r.get 'flights' do
              params_hash = Hash[r.params.map{|(k,v)| [k.to_sym,v]}] # keys need to be converted to symbols for Validations to work!
              request = LufthansaApiCalls.new(params_hash).validate_request_params
              request[:error] ? r.halt(400, errors: request[:messages]) : LufthansaApiCalls.new(params_hash).get_flights
            end

            r.get 'destinations' do
              airport = r.params['airport']
              unless airport.nil? || airport.empty?
                # validate airport code
                # get all selected airport destinations
                validations = ParamValidations.new(r.params).validate_request_params
                request[:error] ? r.halt(400, errors: request[:messages]) : Airports.new(r.params['airport']).get_airport_non_stop_destinations
              else
                r.halt(400, message: ErrorMessages::MISSING_PARAMS )
              end
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
