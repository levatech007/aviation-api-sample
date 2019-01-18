class App
  require 'rest-client'

  route 'v1' do |r|
    r.on 'welcome' do
      r.get 'flights' do
        api_key = r.params['api_key']
        p( r.params)
        if api_key
          if ValidateApiKey.new(api_key).api_key_valid?
            if RateLimiting.new.rate_limit_not_exceeded?(api_key)
              #validate request params
              #if LufthansaApiCalls.new(r.params).get_request_params_valid?
              response = LufthansaApiCalls.new(r.params).get_flights
              JSON.parse(response)
              #add error handling
            else
              r.halt(
                429,
                error: 'Too many requests',
                message: ErrorMessages::LIMIT_EXCEEDED
              )
            end
          else
            r.halt(
              401,
              error: 'Unauthorized',
              message: ErrorMessages::API_KEY_INVALID
            )
          end
        else
          r.halt(
            400,
            error: 'Bad request',
            message: ErrorMessages::QUERY_INVALID
          )
        end
      end
    end
  end
end
