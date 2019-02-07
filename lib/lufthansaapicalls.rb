# calls to Lufthansa (LH) API
class LufthansaApiCalls
  require 'date'
  require 'rest-client'
  require './lib/gettoken.rb'
  require './lib/airportsdata.rb'

  LH_BASE_URL = 'https://api.lufthansa.com/v1/operations/schedules/'
  #url = 'https://api.lufthansa.com/v1/operations/schedules/FRA/SFO/2019-02-24?directFlights=1'
  def initialize(request_params)
    @departing_from = request_params['departing_from']
    @arriving_to    = request_params['arriving_to']
    @date           = request_params['date']
    @direct_flights = request_params['direct_flights']
  end

  def validate_request_params
    # validate date format (for LH, YYYY-MM-DD)
    messages = []

    messages.push('Invalid departing_from airport code') if !Airport.find(airport_iata_code: @departing_from)
    messages.push('Invalid arriving_to airport code') if !Airport.find(airport_iata_code: @arriving_to)

    if @date.length == 10
      begin
        converted_date = Date.strptime(@date, '%Y-%m-%d')
      rescue ArgumentError => e
        messages.push('Date is not valid')
        return { error: true, messages: messages}
      end
      if converted_date < Date.today
        messages.push('Date is in the past')
      end
    else
      messages.push('Date is not valid. Please check your date format ("YYYY-MM-DD").')
    end


    #if @direct_flights != 1 || @direct_flights != 0 # { error: "Direct flights option not selected" }

    error = messages.size > 0 ? true : false
    response = {
              error: error,
              messages: messages
            }
    return response

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
