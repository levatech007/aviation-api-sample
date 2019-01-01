class App
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
              # Auth format to send: "Bearer kfu894usdbj"
              auth = "#{lh_token['token_type'].capitalize} #{lh_token['access_token']}"
              # hardcoded url params for now
              url = 'https://api.lufthansa.com/v1/operations/schedules/FRA/SFO/2019-02-24?directFlights=1'
              RestClient::Request.execute(
                method: :get,
                url: url,
                headers: { Authorization: auth, Accept: 'application/json' }
              ) { |response|
                  # errors are not DRY, need better solution. Maybe separate class?
                  case response.code
                  when 200
                    response
                  when 400
                    r.halt(
                      400,
                      error: 'Bad request',
                      message: ErrorMessages::CHECK_SPELLING
                    )
                  else
                    r.halt(
                      400,
                      error: 'Bad request',
                      message: ErrorMessages::GENERAL_ERROR
                    )
                  end
              }
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
