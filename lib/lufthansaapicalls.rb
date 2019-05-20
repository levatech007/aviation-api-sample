# calls to Lufthansa (LH) API
class LufthansaApiCalls
  require 'json'
  require 'date'
  require 'rest-client'
  require './lib/gettoken.rb'
  require './lib/errormessages.rb'

  LH_BASE_URL = 'https://api.lufthansa.com/v1/operations/schedules/'

  def initialize(request_params)
    @from    = request_params[:from].upcase
    @to      = request_params[:to].upcase
    @date    = request_params[:date]
    @nonstop = request_params[:nonstop] # should default to 0
  end

  def validate_request_params
    messages = []
    # validate airport codes
    messages.push(ErrorMessages::DEPARTURE_INVALID) if !Airport.find(airport_iata_code: @from)
    messages.push(ErrorMessages::ARRIVAL_INVALID)   if !Airport.find(airport_iata_code: @to)

    # check if direct_flights is present
    if @nonstop != 0 || @nonstop != 1
      @nonstop = 0
    end
    # if present, it can be 1 or 0
    # if not present, default to 0,

    if @date.length == 10
      begin
        converted_date = Date.strptime(@date, '%Y-%m-%d')
      rescue ArgumentError => e
        messages.push(ErrorMessages::LH_DATE_INVALID)
        return { error: true, messages: messages}
      end
      if converted_date < Date.today # make sure date is in the future
        messages.push(ErrorMessages::PAST_DATE)
      elsif converted_date > Date.today + 364 # but not more than 1 year into the future
        messages.push(ErrorMessages::FUTURE_DATE)
      end
    else
      messages.push(ErrorMessages::LH_DATE_INVALID)
    end

    response = { error: !messages.empty? , messages: messages }
    return response

  end

  def get_flights
    # get current token from Redis by key (ex. lhtoken:week21:day5)
    # Auth format LH expects: "Bearer kfu894usdbj"
    today = Date.today
    redis = Redis.new
    redis_key = "lhtoken:week#{today.cweek}:day#{today.cwday}"
    get_lh_token = redis.get(redis_key)
    # convert to hash
    lh_token = JSON.parse(get_lh_token, symbolize_names: true)
    auth     = "#{lh_token[:token_type].capitalize} #{lh_token[:access_token]}"
    # expected (example) url: LH_BASE_URL/SFO/FRA/2019-06-01?directFlights=1
    url      = LH_BASE_URL + "#{ @from }/#{ @to }/#{ @date }?directFlights=#{ @nonstop }"
    RestClient::Request.execute(
                                  method:   :get,
                                  url:      url,
                                  headers:  { Authorization: auth, Accept: 'application/json' }
                                ) { |response|
                                  # add handling if there are no flights to return!
                                  data          = JSON.parse(response, symbolize_names: true)
                                  flights_data  = data[:ScheduleResource][:Schedule]
                                  response.code == 200 ? format_get_flights_data(flights_data) : { error: "Something went wrong with LH" }
                                }
  end

  def format_get_flights_data(flights_data)
    journey_options = []
    flights_data.map { |journey|  journey_options.push(format_one_journey(journey))}

    result = {
                results_count:    flights_data.length,
                journey_options:  journey_options
              }
    # handle errors
    return result
  end

  def format_one_journey(journey)
    # journey['Flight'] is an object if the entire journey is a single non-stop flight,
    # otherwise it is an array of objects where each objects contains a single leg flight of the journey
    if journey[:Flight].kind_of?(Array)
      journey_flights, journey_stops   = [], journey[:Flight].length - 1
      journey[:Flight].each { |flight| journey_flights.push(format_single_flight(flight))}
    else
      journey_flights, journey_stops   = format_single_flight(journey[:Flight]), 0
    end

    one_formatted_journey = {
                               #route:             "FRA to SFO via MUC", # template string of all airports
                               stops:             journey_stops,
                               journey_duration:  journey[:TotalJourney][:Duration].gsub(/[PT]/, ""), # LH string: "P[n]NDT[n]NH[n]NM"
                               flights:           journey_flights
                            }
    # handle errors
    return one_formatted_journey
  end

  def format_single_flight(flight)
    # all flights have 'MarketingCarrier' that is LH, LH own flights ONLY have 'MarketingCarrier'
    # if operated by airline other than LH, 'OperatingCarrier' is included and should be used
    carrier = flight.key?(:OperatingCarrier) ?  'OperatingCarrier' : 'MarketingCarrier'
    one_formatted_flight = {
                              flight_number:          "#{flight[carrier][:AirlineID]}#{flight[carrier][:FlightNumber]}",
                              operated_by:            Airline.where(airline_iata_code: flight[carrier][:AirlineID]).get(:airline_name),
                              departure_airport:      flight[:Departure][:AirportCode],
                              departure_airport_name: Airport.where(airport_iata_code: flight[:Departure][:AirportCode]).get(:airport_name),
                              departure_time_local:   flight[:Departure][:ScheduledTimeLocal][:DateTime],
                              arrival_airport:        flight[:Arrival][:AirportCode],
                              arrival_airport_name:   Airport.where(airport_iata_code: flight[:Arrival][:AirportCode]).get(:airport_name),
                              arrival_time_local:     flight[:Arrival][:ScheduledTimeLocal][:DateTime],
                              aircraft_type:          Aircraft.where(iata_aircraft_code: flight[:Equipment][:AircraftCode].to_s).get(:aircraft_name)
                          }
    # handle errors
    return one_formatted_flight
  end

end
