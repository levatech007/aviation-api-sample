class Airports

  def initialize(airport_iata_code)
    @airport_iata_code = airport_iata_code
  end

  # def valid_iata_airport_code?
  #   return true if Airport.find(airport_iata_code: @airport_iata_code)
  #   false
  # end

  def get_airport_destinations
    @destinations = Airport.where(airport_iata_code: @airport_iata_code).get(:destinations)
    result = {
                airport:      @airport_iata_code,
                destinations: @destinations.split(",").sort
              }

  end

end
