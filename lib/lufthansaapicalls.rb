# calls to Lufthansa (LH) API
class LufthansaApiCalls
  require 'rest-client'
  require './lib/gettoken.rb'

  LH_BASE_URL = 'https://api.lufthansa.com/v1/operations/schedules/'
    #url = 'https://api.lufthansa.com/v1/operations/schedules/FRA/SFO/2019-02-24?directFlights=1'
  def initialize(request_params)
    @departing_from = request_params['departing_from']
    @arriving_to = request_params['arriving_to']
    @date = request_params['date']
    @direct_flights = request_params['direct_flights']
  end

  def get_request_params_valid?
    #validate airport codes (3 characters, convert to upper case)
    #validate date(make sure it is in the future)
    #validate date format (YYYY-MM-DD)
    #validate direct_flights (0 or 1 only)
  end

  def get_flights
    lh_token = GetToken.new.obtain_lh_token
    # Auth format to send: "Bearer kfu894usdbj"
    auth = "#{lh_token['token_type'].capitalize} #{lh_token['access_token']}"
    url = LH_BASE_URL + "#{ @departing_from }/#{ @arriving_to }/#{ @date }?directFlights=#{ @direct_flights }"
    RestClient::Request.execute(
      method: :get,
      url: url,
      headers: { Authorization: auth, Accept: 'application/json' }
    ) { |response|
      return response
    }
  end

end
