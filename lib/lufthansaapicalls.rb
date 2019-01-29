# calls to Lufthansa (LH) API
class LufthansaApiCalls < Roda
  require 'date'
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

  def request_params_valid?
    # validate date format (for LH, YYYY-MM-DD)
    if @date.length == 10
      begin
        converted_date = Date.strptime(@date, '%Y-%m-%d')
      rescue ArgumentError => e
        return false
        # {message: "Date is not valid"}
      end
      if converted_date < Date.today
        return false
        # { message: "Date is in the past" }
      end
    else
      return false # { error: "Date not valid. Format: YYYY-MM-DD" }
    end
    # better error handling needed; currently just returns message with 200/ok
    return false if @departing_from.length != 3 || @arriving_to.length != 3 # { error: "Airport code invalid" } => move to airportsdata.rb
    #return false if @direct_flights != 1 || @direct_flights != 0 # { error: "Direct flights option not selected" }


    return true #if all are valid
  end

  def get_flights
    lh_token = GetToken.new.obtain_lh_token
    # Auth format LH expects: "Bearer kfu894usdbj"
    auth = "#{lh_token['token_type'].capitalize} #{lh_token['access_token']}"
    url = LH_BASE_URL + "#{ @departing_from }/#{ @arriving_to }/#{ @date }?directFlights=#{ @direct_flights }"
    RestClient::Request.execute(
      method: :get,
      url: url,
      headers: { Authorization: auth, Accept: 'application/json' }
    ) { |response|
      response.code == 200 ? JSON.parse(response) : {error: "Something went wrong with LH"} # +needs to return error code
    }

  end

end
