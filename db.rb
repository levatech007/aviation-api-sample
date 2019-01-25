begin
  require_relative '.env.rb'
rescue LoadError
end

#require 'sequel'
require 'sequel/core'
#require 'sequel/extensions/seed'
#Sequel.extension :seed
# Delete APP_DATABASE_URL from the environment, so it isn't accidently
# passed to subprocesses.  APP_DATABASE_URL may contain passwords.
DB = Sequel.connect(ENV.delete('APP_DATABASE_URL') || ENV.delete('DATABASE_URL'))
#Sequel::Seeder.apply(DB, '/seeds/seed.rb')

# sequel/extensions/seed => module not found
# initial fix for seeding DB. Comment out the following variables, arrays and functions after items entered into DB after running $ rackup
# run when there are changes to seed data
# get seed file from /seeds/seed.rb
# clear DB entries before running the seeds or check if entries already exist.

# airports = DB[:airports]
# airports_list = [
#     ["Anaa", "AAA", "NTGA", -17.05, -145.41667, "Pacific/Tahiti", -10, "French Polynesia", "PF", "AAA"],
#     ["Arrabury", "AAB", "YARY", -26.7, 141.04167, "Australia/Brisbane", 10, "Australia", "AU", "AAB"],
#     ["El Arish International Airport", "AAC", "HEAR", 31.133333, 33.75, "Africa/Cairo", 2, "Egypt", "EG", "AAC"],
#     ["Les Salines", "AAE", "DABB", 36.821392, 7.811857, "Africa/Algiers", 1, "", "DZ", "AAE"],
#     ["Apalachicola Regional", "AAF", "KAAF", 29.733334, -84.98333, "America/New_York", -5, "United States", "US", "AAF"],
#     ["Arapoti", "AAG", "SSYA", -24.103611, -49.79, "America/Sao_Paulo", -3, "Brazil", "BR", "AAG"],
#     ["Aachen/Merzbruck", "AAH", "EDKA", 50.75, 6.133333, "Europe/Berlin", 1, "Germany", "DE", "AAH"],
#     ["Arraias", "AAI", "SWRA", -12.916667, -46.933334, "America/Araguaina", -3, "Brazil", "BR", "AAI"],
#     ["Cayana Airstrip", "AAJ", "", 3.9, -55.36667, "America/Paramaribo", -3, "Suriname", "SR", "AAJ"],
#     ["Aranuka", "AAK", "NGUK", 0.166667, 173.58333, "Pacific/Tarawa", 12, "Kiribati", "KI", "AAK"]
# ]
#   airports_list.each do |airport|
#     airports.insert(airport_name: airport[0], airport_iata_code: airport[1], airport_icao_code: airport[2], latitude: airport[3], longitude: airport[4], timezone: airport[5], gmt: airport[6], country_name: airport[7], iso2_country_code: airport[8], iata_city_code: airport[9])
#
#   end
