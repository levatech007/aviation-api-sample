class SeedDatabase
  require 'json'
  require 'rest-client'

  def get_data(url_param)
    response = RestClient.get("#{ENV['VOLO_APPS_SCRIPT_URL']}?q=#{url_param}")
    data = JSON.parse(response)
  end

  # def seed_airports_database
  #
  # end

  # def seed_airlines_database
  #
  # end

  def seed_aircraft_database
    # 2 separated sources for aircraft data:
    url_param = 'aircrafts'
    # get data from apps script sheet:
    aircraft_data = get_data(url_param)
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
    url_param = 'airports'
    airports_data = get_data(url_param)

    file = File.read('./seeds/formatted_airports_data.json')
    airports_data_file = JSON.parse(file)

    airports_data.map do |airport|
      # find same airport from airport_data_file and combine the results: (match iata_code with airport_iata_code)
      # format airport database entry
      airport_from_file = airport_data_file.find { |airport_obj| airport_obj[:iata] == airport['airport_iata_code'] }
      Airport.insert(
                        airport_name:       airport_from_file['airport_name'],
                        airport_iata_code:  airport['iata_code'],
                        airport_icao_code:  airport_from_file['airport_icao_code'],
                        latitude:           airport_from_file['latitude'],
                        longitude:          airport_from_file['longitude'],
                        timezone:           airport_from_file['timezone'],
                        gmt:                airport_from_file['gmt'],
                        country_name:       airport_from_file['country_name'],
                        iso2_country_code:  airport_from_file['iso2_country_code'],
                        iata_city_code:     airport_from_file['iata_city_code'],
                        airport_city:       airport['city']
                    )
      # add airport destinations to Destinations join table
    end
  end

  # add non-stop destinations to airports
  def add_destinations_to_airport(airport_iata_code)
    # get the data from apps script database
    p("Running seed destinations!")
    url_extension = "destinations/#{ airport_iata_code }"
    # if the airport has destinations available in apps script,
    # get the airport from db, add a foreign key to Destinations join table
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
