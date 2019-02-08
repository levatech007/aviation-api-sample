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
    messages = []
    # vaidate iata airport code, still need to handle case sensitivity!
    messages.push('Invalid departing_from airport code') if !Airport.find(airport_iata_code: @departing_from)
    messages.push('Invalid arriving_to airport code')    if !Airport.find(airport_iata_code: @arriving_to)

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

    error    = messages.size > 0 ? true : false
    response = { error: error, messages: messages }
    return response

  end

  def get_flights
    # Auth format LH expects: "Bearer kfu894usdbj"
    lh_token = GetToken.new.obtain_lh_token
    auth     = "#{lh_token['token_type'].capitalize} #{lh_token['access_token']}"
    url      = LH_BASE_URL + "#{ @departing_from }/#{ @arriving_to }/#{ @date }?directFlights=#{ @direct_flights }"
    RestClient::Request.execute(
                                  method:   :get,
                                  url:      url,
                                  headers:  { Authorization: auth, Accept: 'application/json' }
                                ) { |response|
                                  # data = JSON.parse(response)
                                  # flights_data = data['ScheduleResource']['Schedule']
                                  #  response.code == 200 ? format_get_flights_data(flights_data) : { error: "Something went wrong with LH" }

                                  response.code == 200 ? JSON.parse(response) : { error: "Something went wrong with LH" } # +needs to return error code
                                }

  end

  # journey is the complete one-way trip
  def format_get_flights_data(flights_data)
    # all_journeys = flights_data['ScheduleResource']['Schedule']
    # use flights['OperatingCarrier'] over ['MarketingCarrier'] if it is present
    # {
    #   "results_count": flights.length,
    #   "flight_options": [ return format_one_journey per each complete trip offered ]
    #}
  end

  def format_one_journey(journey)
    # => journey is an object
    # all_airports =
    # {
    #  route: "FRA => MUC => SFO",
    #  stops: flights['flights'].kind_of?(Array) ? flights['flight'].length - 1 : 0
    #  total_journey_duration: convert_journey_duration(flights['TotalJourney']['Duration']),
    #  flights: [
    #              return format_single_flight(flight) per each flight in array or object
    #             ]
    # }
  end

  def format_single_flight(flight)
    # => returns a hash
    carrier = flight.key?('OperatingCarrier') ?  'OperatingCarrier' : 'MarketingCarrier'
    {
      flight_number:          "#{flight[carrier][AirlineID]}#{flight[carrier][FlightNumber]}",
      operated_by:            Airline.where(airline_iata_code: flight[carrier][AirlineID])).get(:airline_name),
      departure_airport:      flight['Departure']['AirportCode'],
      departure_airport_name: get from db by iata code
      departure_time_local:   flight['Departure']['ScheduledTimeLocal']['DateTime'],
      arrival_airport:        flight['Arrival']['AirportCode'],
      arrival_time_local:     flight['Arrival']['ScheduledTimeLocal']['DateTime'],
      aircraft_type:          Aircraft.where(iata_aircraft_code: flight['Equipment']['AircraftCode']).get(:aircraft_name)
    }
  end

  def convert_journey_duration(time)
    # time => duration string from LH
    # Format: P[n]nDT[n]nH[n]nM. Hours and minutes can be single digits.
    # output string in hours and minutes => "17H15M"
  end

end
