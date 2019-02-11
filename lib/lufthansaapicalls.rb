# calls to Lufthansa (LH) API
class LufthansaApiCalls
  require 'json'
  require 'date'
  require 'rest-client'
  require './lib/gettoken.rb'
  require './lib/errormessages.rb'

  LH_BASE_URL = 'https://api.lufthansa.com/v1/operations/schedules/'

  def initialize(request_params)
    @departing_from = request_params['departing_from']
    @arriving_to    = request_params['arriving_to']
    @date           = request_params['date']
    @direct_flights = request_params['direct_flights'] # should default to 0
  end

  def validate_request_params
    messages = []
    # vaidate iata airport code, still need to handle case sensitivity!
    messages.push(ErrorMessages::DEPARTURE_INVALID) if !Airport.find(airport_iata_code: @departing_from.upcase)
    messages.push(ErrorMessages::ARRIVAL_INVALID)   if !Airport.find(airport_iata_code: @arriving_to.upcase)

    if @date.length == 10
      begin
        converted_date = Date.strptime(@date, '%Y-%m-%d')
      rescue ArgumentError => e
        messages.push(ErrorMessages::LH_DATE_INVALID)
        return { error: true, messages: messages}
      end
      if converted_date < Date.today
        messages.push(ErrorMessages::PAST_DATE)
      end
    else
      messages.push(ErrorMessages::LH_DATE_INVALID)
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
                                  # what happens if there are no flights to return???
                                  # eventually should return flights in order: by stops, duration
                                  data = JSON.parse(response)
                                  flights_data = data['ScheduleResource']['Schedule']
                                  response.code == 200 ? format_get_flights_data(flights_data) : { error: "Something went wrong with LH" }

                                  #response.code == 200 ? JSON.parse(response) : { error: "Something went wrong with LH" } # +needs to return error code
                                }

  end

  def format_get_flights_data(flights_data)
    journey_options = []
    flights_data.map { |journey|  journey_options.push(format_one_journey(journey))}

    result = {
                results_count: flights_data.length,
                journey_options: journey_options
              }
    # handle errors
    return result
  end

  def format_one_journey(journey)
    # journey['Flight'] is an object if the entire journey is a single non-stop flight,
    # otherwise it is an array of objects where each objects contains a single leg flight of the journey
    if journey['Flight'].kind_of?(Array)
      journey_flights, journey_stops   = [], journey['Flight'].length - 1
      journey['Flight'].each { |flight| journey_flights.push(format_single_flight(flight))}
    else
      journey_flights, journey_stops   = format_single_flight(journey['Flight']), 0
    end

    one_formatted_journey = {
                               #route:             "FRA to SFO via MUC", # template string of all airports
                               stops:             journey_stops,
                               journey_duration:  journey['TotalJourney']['Duration'].gsub(/[PT]/, ""),
                               flights:           journey_flights
                            }
    # handle errors
    return one_formatted_journey
  end

  def format_single_flight(flight)
    # all flights have 'MarketingCarrier' that is LH, LH own flights ONLY have 'MarketingCarrier'
    # if operated by airline other than LH, 'OperatingCarrier' is included and should be used
    carrier = flight.key?('OperatingCarrier') ?  'OperatingCarrier' : 'MarketingCarrier'
    one_formatted_flight = {
                              flight_number:          "#{flight[carrier]['AirlineID']}#{flight[carrier]['FlightNumber']}",
                              operated_by:            Airline.where(airline_iata_code: flight[carrier]['AirlineID']).get(:airline_name),
                              departure_airport:      flight['Departure']['AirportCode'],
                              departure_airport_name: Airport.where(airport_iata_code: flight['Departure']['AirportCode']).get(:airport_name),
                              departure_time_local:   flight['Departure']['ScheduledTimeLocal']['DateTime'],
                              arrival_airport:        flight['Arrival']['AirportCode'],
                              arrival_airport_name:   Airport.where(airport_iata_code: flight['Arrival']['AirportCode']).get(:airport_name),
                              arrival_time_local:     flight['Arrival']['ScheduledTimeLocal']['DateTime'],
                              aircraft_type:          Aircraft.where(iata_aircraft_code: flight['Equipment']['AircraftCode'].to_s).get(:aircraft_name)
                          }
    # handle errors
    return one_formatted_flight
  end

end
