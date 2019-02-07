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
# get seed file from /seeds/seed.rb
# clear DB entries before running the seeds or check if entries already exist.


# SEED AIRPORT DATABASE BELOW (WORKING SOLUTION):
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
