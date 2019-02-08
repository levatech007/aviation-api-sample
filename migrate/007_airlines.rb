Sequel.migration do
  change do
    create_table(:airlines) do
      primary_key :id, unique: true
      String :airline_name
      String :airline_iata_code
      String :airline_icao_code
      String :country_name
      String :iata_hub_code
      String :iso2_country_code
      String :callsign
    end
  end
end
