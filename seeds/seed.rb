


Sequel.seed do
  def run
    [
      ["Anaa", "AAA", "NTGA", -17.05, -145.41667, "Pacific/Tahiti", -10, "French Polynesia", "PF", "AAA"],
      ["Arrabury", "AAB", "YARY", -26.7, 141.04167, "Australia/Brisbane", 10, "Australia", "AU", "AAB"],
      ["El Arish International Airport", "AAC", "HEAR", 31.133333, 33.75, "Africa/Cairo", 2, "Egypt", "EG", "AAC"],
      ["Les Salines", "AAE", "DABB", 36.821392, 7.811857, "Africa/Algiers", 1, "", "DZ", "AAE"],
      ["Apalachicola Regional", "AAF", "KAAF", 29.733334, -84.98333, "America/New_York", -5, "United States", "US", "AAF"],
      ["Arapoti", "AAG", "SSYA", -24.103611, -49.79, "America/Sao_Paulo", -3, "Brazil", "BR", "AAG"],
      ["Aachen/Merzbruck", "AAH", "EDKA", 50.75, 6.133333, "Europe/Berlin", 1, "Germany", "DE", "AAH"],
      ["Arraias", "AAI", "SWRA", -12.916667, -46.933334, "America/Araguaina", -3, "Brazil", "BR", "AAI"],
      ["Cayana Airstrip", "AAJ", "", 3.9, -55.36667, "America/Paramaribo", -3, "Suriname", "SR", "AAJ"],
      ["Aranuka", "AAK", "NGUK", 0.166667, 173.58333, "Pacific/Tarawa", 12, "Kiribati", "KI", "AAK"]
    ].each do |airport_name, airport_iata_code, airport_icao_code, latitude, longitude, timezone, gmt, country_name,iso2_country_code, iata_city_code|
      Airport.create airport_name: airport_name, airport_iata_code: airport_iata_code, airport_icao_code: airport_icao_code, latitude: latitude, longitude: longitude, timezone: timezone, gmt: gmt, country_name: country_name, iso2_country_code: iso2_country_code, iata_city_code: iata_city_code

    end
  end
end
