class Airports

  def initialize(airport_iata_code)
    @airport_iata_code = airport_iata_code
  end

  def validate_airport
    # validate airport code 
  end

  def get_airport_destinations
    @destinations = Airport.where(airport_iata_code: @airport_iata_code).get(:destinations)
    result = {
      airport: @airport_iata_code,
      destinations: @destinations.split(",").sort
    }

  end

end
