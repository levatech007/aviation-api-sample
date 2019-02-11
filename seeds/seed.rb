class SeedDatabase
  require 'json'
  require 'sequel/core'
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
    aircraft_data = get_data()
    aircraft_data['data'].map do |aircraft|
      p(aircraft)
      Aircraft.insert(
        iata_aircraft_code:  aircraft['iata_code'],
        icao_aircraft_code:  aircraft['icao_code'],
        aircraft_name:       aircraft['aircraft_model'],
        wake_category:       "n/a"
                   )

    end
  end

end
