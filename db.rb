begin
  require_relative '.env.rb'
rescue LoadError
end

require 'sequel/core'
require 'rest-client'
require 'json'
# Delete APP_DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  APP_DATABASE_URL may contain passwords.
DB = Sequel.connect(ENV.delete('APP_DATABASE_URL') || ENV.delete('DATABASE_URL'))

# initial fix for seeding DB. Comment out the following variables, arrays and functions after items entered into DB after running $ rackup
# run when there are changes to seed data
# clear DB entries before running the seeds or check if entries already exist.

# SEED DATABASES BELOW (NOT IDEAL BUT A WORKING SOLUTION FOR NOW):

# => SEED AIRPORT DATA
# airports = DB[:airports]
# airports.delete # CAREFUL! DELETES ALL PREVIOUS ENTRIES
# file = File.read('seeds/formatted_airports_data.json')
# data = JSON.parse(file)
# airport_list = data['airports']
# airport_list.map do |airport|
#     airport_json = JSON.parse(airport)
#     airports.insert(
#                       airport_name:       airport_json['airport_name'],
#                       airport_iata_code:  airport_json['airport_iata_code'],
#                       airport_icao_code:  airport_json['airport_icao_code'],
#                       latitude:           airport_json['latitude'],
#                       longitude:          airport_json['longitude'],
#                       timezone:           airport_json['timezone'],
#                       gmt:                airport_json['gmt'],
#                       country_name:       airport_json['country_name'],
#                       iso2_country_code:  airport_json['iso2_country_code'],
#                       iata_city_code:     airport_json['iata_city_code']
#                     )
#   end

# => SEED AIRCRAFT DATA
# aircrafts = DB[:aircrafts]
# aircrafts.delete # CAREFUL! DELETES ALL PREVIOUS ENTRIES
# file = File.read('seeds/formatted_aircrafts_data.json')
# data = JSON.parse(file)
# airport_list = data['aircrafts']
# airport_list.map do |aircraft|
#     aircraft_json = JSON.parse(aircraft)
#     aircrafts.insert(
#                       iata_aircraft_code:  aircraft_json['iata_aircraft_code'],
#                       icao_aircraft_code:  aircraft_json['icao_aircraft_code'],
#                       aircraft_name:       aircraft_json['aircraft_name'],
#                       wake_category:       aircraft_json['wake_category']
#                     )
#   end

# => SEED AIRLINES DATA:
# airlines = DB[:airlines]
# airlines.delete # CAREFUL! DELETES ALL PREVIOUS ENTRIES
# file = File.read('seeds/formatted_airlines_data.json')
# data = JSON.parse(file)
# airlines_list = data['airlines']
# airlines_list.map do |airline|
#     airline_json = JSON.parse(airline)
#     airlines.insert(
#                       airline_iata_code:  airline_json['airline_iata_code'],
#                       airline_icao_code:  airline_json['airline_icao_code'],
#                       airline_name:       airline_json['airline_name'],
#                       callsign:           airline_json['callsign'],
#                       iata_hub_code:      airline_json['iata_hub_code'],
#                       country_name:       airline_json['country_name'],
#                       iso2_country_code:  airline_json['iso2_country_code']
#                     )
#   end







#OUTDATED BELOW, NEEDS UPDATING to match seed database formatting
# adds destinations to each airport:
# airports = DB[:airports]
# response = RestClient.get(ENV['APPS_SCRIPT_URL'])
# destinations_data = JSON.parse(response)
# destinations_data.each do |airport_data|
#   p airport_data['airportIataCode']
#   all_destinations = []
#   airport_data['data'].each do |airline|
#     all_destinations << airline['destinations']
#   end
#   unique_destinations = all_destinations.join(",").split(",").uniq.join(",")
#   airports.where(airport_iata_code: airport_data['airportIataCode']).update(destinations: unique_destinations)
# end
