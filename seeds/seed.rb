require 'sequel/core'
#seed airports to DB
airports = DB[:airports]
airports.delete # CAREFUL! DELETES ALL PREVIOUS ENTRIES
airports_list = [
  ["an Francisco International", "SFO", "KSFO", 37.615215, -122.38988, "America/Los_Angeles", -8, "United States", "US", "SFO"],
  ["rincess Juliana International", "SXM", "TNCM", 18.044722, -63.11406, "America/Lower_Princes", -4, "Sint Maarten", "SX", "SXM"],
  ["os Angeles International", "LAX", "KLAX", 33.943398, -118.40828, "America/Los_Angeles", -8, "United States", "US", "LAX"]
 ]
   airports_list.each do |airport|
     airports.insert(airport_name: airport[0], airport_iata_code: airport[1], airport_icao_code: airport[2], latitude: airport[3], longitude: airport[4], timezone: airport[5], gmt: airport[6], country_name: airport[7], iso2_country_code: airport[8], iata_city_code: airport[9])
   end
