class SeedDatabase
  require 'json'
  require 'rest-client'
  Dir['./scraping/*.rb'].each {|file| require file }

  def get_data_from_apps_script(url_param)
    response = RestClient.get("#{ENV['VOLO_APPS_SCRIPT_URL']}?q=#{url_param}")
    data = JSON.parse(response)
  end

  def get_data
    response = RestClient.get("#{ENV['AIRPORT_DB_URL']}?key=#{ ENV['AIRPORT_DB_KEY'] }")
    data = JSON.parse(response)
  end

  def seed_aircraft_database
    # 2 separated sources for aircraft data:
    url_param = 'aircrafts'
    # get data from apps script sheet:
    aircraft_data = get_data_from_apps_script(url_param)
    aircraft_data['data'].map do |aircraft|
      Aircraft.insert(
        iata_aircraft_code:  aircraft['iata_code'],
        icao_aircraft_code:  aircraft['icao_code'],
        aircraft_name:       aircraft['aircraft_model'].gsub!("\n","") , # remove newline!
        wake_category:       "n/a"
                   )
    end

    # add in data from a json file:
    file = File.read('./seeds/formatted_aircrafts_data.json')
    data = JSON.parse(file)
    aircraft_list = data['aircrafts']
    aircraft_list.map do |aircraft|
      aircraft_json = JSON.parse(aircraft)
      if !Aircraft.find(iata_aircraft_code: aircraft_json['iata_aircraft_code'])
          Aircraft.insert(
                          iata_aircraft_code:  aircraft_json['iata_aircraft_code'],
                          icao_aircraft_code:  aircraft_json['icao_aircraft_code'],
                          aircraft_name:       aircraft_json['aircraft_name'],
                          wake_category:       aircraft_json['wake_category']
                        )
      # else: if Aircraft is found and wake_category is "n/a", add wake category
      end
    end
  end

  def seed_airports_database
    # delete all airport database entries before seeding database
    # get scraped data:
    scraped_airports_data = ScrapeIataCodes.new.scrape_iata_codes # array of hashes
    # use: 'airport_iata_code', 'airport_icao_code', 'airport_wiki_page' !!USE AIRPORTS WITH ICAO CODES!!

    airports_data = get_data()
    # use 'airport_name', 'latitude', 'longitude', 'timezone', 'gmt', 'country_name', 'iso2_country_code', 'iata_city_code'

    scraped_airports_data.map do |scraped_airport|
      if(scraped_airport[:airport_icao_code] != "") # icao code exists only for airports; iata also includes bus and train stations
        airport_info = airports_data.find { |airport| airport['codeIataAirport'] ==  scraped_airport[:airport_iata_code] }
        if(!airport_info.nil?)
          Airport.insert(
                           airport_iata_code:  scraped_airport[:airport_iata_code],
                           airport_icao_code:  scraped_airport[:airport_icao_code],
                           airport_wiki_page:  scraped_airport[:airport_wiki_page],
                           airport_name:       airport_info['nameAirport'],
                           latitude:           airport_info['latitudeAirport'].to_f,
                           longitude:          airport_info['longitudeAirport'].to_f,
                           timezone:           airport_info['timezone'],
                           gmt:                airport_info['GMT'].to_i,
                           country_name:       airport_info['nameCountry'],
                           iso2_country_code:  airport_info['codeIso2Country'],
                           iata_city_code:     airport_info['codeIataCity']
                         )
        end
      end
    end

  end

  # add non-stop destinations to airports after seeding airports data
  def add_destinations_to_airport
    # move to store these in Redis in the future
    # run for all airports that have correct wiki page that includes '/wiki/'
    Airport.each do |airport|
      # if the airport has a wiki page that includes /wiki/:
      # (although most other links should be eliminated, keep below as a safeguard for now):
      if airport[:airport_wiki_page].include?('/wiki/')
        destinations = ScrapeAirportDestinations.new(airport[:airport_wiki_page]).scrape_destinations

        unless destinations.kind_of?(String) # if no destinations are found (usual for smaller airports), string is returned for now
          unless destinations[:regular].empty? # some smaller airports don't have regularly scheduled flights
            destinations[:regular].each do |destination| # => object with 'regular', 'seasonal', 'seasonalcharter' keys
              # some still have no wiki page link:
              unless destination[:wiki_page].nil?
                # find destination airport by wiki page
                # some wiki page links are not an exact match in different locations
                destination_airport = Airport.find(airport_wiki_page: destination[:wiki_page])
                # if destination airport is not found, scrape the iata code separately from airport wiki page:
                if destination_airport.nil?
                  destination_airport_iata_code = ScrapeAirportIataCode.new(destination[:wiki_page]).get_airport_iata_code
                  # set the wiki page to airport_wiki_page_alternate in DB
                  destination_airport = Airport.find(airport_iata_code: destination_airport_iata_code)
                  if !destination_airport.nil? && destination_airport[:airport_iata_code].length == 3 # iata code is 3 chars, sometimes returns icao code
                    destination_airport.update(alternate_airport_wiki_page: destination[:wiki_page])
                  end
                end
                  # if found, add to destinations table
                  # check that the association doesn't already exists
                unless destination_airport.nil?
                  if Destination.find(airport_id: airport[:id], destination_id: destination_airport[:id]).nil?
                    # enter new association
                    Destination.insert(airport_id: airport[:id], destination_id: destination_airport[:id])
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def seed_airlines_database
    # below overrides the database. eventually just update existing entries, add new ones
    # delete all entries
    file = File.read('./seeds/formatted_airlines_data.json')
    airlines_data = JSON.parse(file)
    airlines_list = data['airlines']
    airlines_list.map do |airline|
      airline_json = JSON.parse(airline)
      Airline.insert(
                      airline_iata_code:  airline_json['airline_iata_code'],
                      airline_icao_code:  airline_json['airline_icao_code'],
                      airline_name:       airline_json['airline_name'],
                      callsign:           airline_json['callsign'],
                      iata_hub_code:      airline_json['iata_hub_code'],
                      country_name:       airline_json['country_name'],
                      iso2_country_code:  airline_json['iso2_country_code']
                    )
      end
  end

end
