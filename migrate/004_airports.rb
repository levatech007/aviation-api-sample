Sequel.migration do
  change do
    create_table(:airports) do
      primary_key :id, unique: true
      String :airport_name
      String :airport_iata_code
      String :airport_icao_code
      Float :latitude
      Float :longitude
      String :timezone
      Integer :gmt
      String :country_name
      String :iso2_country_code
      String :iata_city_code
    end
  end
end
