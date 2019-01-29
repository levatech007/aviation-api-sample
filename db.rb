begin
  require_relative '.env.rb'
rescue LoadError
end

require 'sequel/core'
require 'rest-client'
# Delete APP_DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  APP_DATABASE_URL may contain passwords.
DB = Sequel.connect(ENV.delete('APP_DATABASE_URL') || ENV.delete('DATABASE_URL'))

# initial fix for seeding DB. Comment out the following variables, arrays and functions after items entered into DB after running $ rackup
# run when there are changes to seed data
# get seed file from /seeds/seed.rb
# clear DB entries before running the seeds or check if entries already exist.

# airports = DB[:airports]
# airports.delete # CAREFUL! DELETES ALL PREVIOUS ENTRIES
# airports_list = [
#   ["San Francisco International", "SFO", "KSFO", 37.615215, -122.38988, "America/Los_Angeles", -8, "United States", "US", "SFO"],
#   ["Princess Juliana International", "SXM", "TNCM", 18.044722, -63.11406, "America/Lower_Princes", -4, "Sint Maarten", "SX", "SXM"],
#   ["Los Angeles International", "LAX", "KLAX", 33.943398, -118.40828, "America/Los_Angeles", -8, "United States", "US", "LAX"]
#  ]
#    airports_list.each do |airport|
#      airports.insert(airport_name: airport[0], airport_iata_code: airport[1], airport_icao_code: airport[2], latitude: airport[3], longitude: airport[4], timezone: airport[5], gmt: airport[6], country_name: airport[7], iso2_country_code: airport[8], iata_city_code: airport[9])
#    end


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
