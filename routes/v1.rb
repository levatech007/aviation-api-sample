class App
  require 'rest-client'

  route 'v1' do |r|
    request_params = Hash[r.params.map{|(k,v)| [k.to_sym,v]}]
    user_api_key = request_params[:api_key]
    r.on 'welcome' do
      # check that there is a (valid) api key and rate limit hasn't been exceeded before proceeding to routes
      unless user_api_key.nil? || user_api_key.empty?
        if ValidateApiKey.new(user_api_key).api_key_valid?
          if RateLimiting.new.rate_limit_not_exceeded?(user_api_key)
            # begin routes
            r.get 'flights' do
              # Required params: from, to, date
              # Optional params: nonstop
              flights_param_validations = ParamValidations.new.validate_flight_request_params(request_params)
              # flights_param_validations[:response] is params hash if no errors are found
              unless flights_param_validations[:errors]
                LufthansaApiCalls.new(flights_param_validations[:response]).get_flights
              else
                r.halt(400, id: ErrorMessages::BAD_REQUEST, errors: flights_param_validations[:response])
              end
            end

            r.get 'destinations' do
              airport = request_params[:airport]
              unless airport.nil? || airport.empty?
                # validate airport code
                # get all selected airport destinations
                destinations_request = ParamValidations.new(r.params).validate_request_params
                destinations_request[:error] ? r.halt(400, errors: destinations_request[:messages]) : Airports.new(request_params[:airport]).get_airport_non_stop_destinations
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
