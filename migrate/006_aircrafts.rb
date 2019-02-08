Sequel.migration do
  change do
    create_table(:aircrafts) do
      primary_key :id, unique: true
      String :iata_aircraft_code
      String :icao_aircraft_code
      String :aircraft_name
      String :wake_category
    end
  end
end
