class SeedDatabase
  require 'json'
  require 'rest-client'

  def get_data()
    response = RestClient.get(ENV['VOLO_APPS_SCRIPT_URL'])
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

    # get data from apps script sheet:
    aircraft_data = get_data()
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
end
