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

  def get_flights
    url      = LH_BASE_URL + "#{ @from }/#{ @to }/#{ @date }?directFlights=#{ @nonstop }"
    current_token = retrieve_lh_token
    # get current token from Redis by key (ex. lhtoken:week21:day5)
    # Auth format LH expects: "Bearer kfu894usdbj"
    auth     = "#{current_token[:token_type].capitalize} #{current_token[:access_token]}"
    # expected (example) url: LH_BASE_URL/SFO/FRA/2019-06-01?directFlights=1
    RestClient::Request.execute(
                                  method:   :get,
                                  url:      url,
                                  headers:  { Authorization: auth, Accept: 'application/json' }
                                ) { |response|
                                  # add handling if there are no flights to return!
                                  data          = JSON.parse(response, symbolize_names: true)
                                  flights_data  = data[:ScheduleResource][:Schedule]
                                  response.code == 200 ? format_get_flights_data(flights_data) : { error: "Error retrieving data from LH" }
                                }
  end

  def retrieve_lh_token
    today        = Date.today
    redis        = Redis.new
    redis_key    = "lhtoken:week#{today.cweek}:day#{today.cwday}"
    get_lh_token = redis.get(redis_key)
    # convert to hash
    lh_token = JSON.parse(get_lh_token, symbolize_names: true)
  end

  def format_get_flights_data(flights_data)
    journey_options = Array.new
    flights_data.map { |journey|  journey_options.push(format_one_journey(journey))}
    result = Hash[:results_count, flights_data.length, :journey_options, journey_options ]
    # handle errors
    return result
  end

  def format_one_journey(journey)
    # journey[:Flight] is an object if the entire journey is a single non-stop flight,
    # otherwise it is an array of objects where each objects contains a single leg flight of the journey
    one_journey = journey[:Flight]
    if one_journey.kind_of?(Array)
      journey_flights, journey_stops   = [], one_journey.length - 1 # e.g.(2 flights == 1 stop )
      one_journey.each { |flight| journey_flights.push(format_single_flight(flight))}
    else
      journey_flights, journey_stops = format_single_flight(one_journey), 0
    end
    one_formatted_journey = Hash[
                                  :stops, journey_stops,
                                  :journey_duration, journey[:TotalJourney][:Duration].gsub(/[PT]/, ''),
                                  :flights, journey_flights
                                ]
    return one_formatted_journey
  end

  def format_single_flight(flight)
    # all flights have 'MarketingCarrier' that is LH, LH own flights ONLY have 'MarketingCarrier'
    # if operated by airline other than LH, 'OperatingCarrier' is included and should be used
    carrier = flight.key? :OperatingCarrier ?  :OperatingCarrier : :MarketingCarrier
    one_formatted_flight = Hash[
                              # flight_number:          "#{flight[carrier][:AirlineID]}#{flight[carrier][:FlightNumber]}",
                              # operated_by:            Airline.where(airline_iata_code: flight[carrier][:AirlineID]).get(:airline_name),
                              :departure_airport,      flight[:Departure][:AirportCode],
                              :departure_airport_name, Airport.where(airport_iata_code: flight[:Departure][:AirportCode]).get(:airport_name),
                              :departure_time_local,   flight[:Departure][:ScheduledTimeLocal][:DateTime],
                              :arrival_airport,        flight[:Arrival][:AirportCode],
                              :arrival_airport_name,   Airport.where(airport_iata_code: flight[:Arrival][:AirportCode]).get(:airport_name),
                              :arrival_time_local,     flight[:Arrival][:ScheduledTimeLocal][:DateTime],
                              :aircraft_type,          Aircraft.where(iata_aircraft_code: flight[:Equipment][:AircraftCode].to_s).get(:aircraft_name)
                          ]
    # handle errors
    return one_formatted_flight
  end

end
