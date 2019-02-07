require 'sequel/core'
#seed airports to DB
airports = DB[:airports]
airports.delete # CAREFUL! DELETES ALL PREVIOUS ENTRIES
file = File.read('formatted_airport_database.json')
data = JSON.parse(file)
data.map do |airport|
    airports.insert(
                      airport_name:       airport['airport_name'],
                      airport_iata_code:  airport['airport_iata_code'],
                      airport_icao_code:  airport['airport_icao_code'],
                      latitude:           airport['latitude'],
                      longitude:          airport['longitude'],
                      timezone:           airport['timezone'],
                      gmt:                airport['gmt'],
                      country_name:       airport['country_name'],
                      iso2_country_code:  airport['iso2_country_code'],
                      iata_city_code:     airport['iata_city_code']
                    )
  end
