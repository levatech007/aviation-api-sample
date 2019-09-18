class ParamValidations
  require 'date'
  @@errors = false
  @@error_messages = []

  def validate_destinations_request_params(airport_code)
    @airport = airport_code
    # validate apirport code
  end

  def validate_flight_request_params(request_params)
    @from = request_params[:from]
    @to = request_params[:from]
    @date = request_params[:from]
    @nonstop = request_params[:from]
    # check if required params are present
    # if not, return error stating what params are missing
    # else validate params
    # return has an array of messages that is empty if no errirs were found
    validate_date
    [@from, @to].each { |airport| validate_airport_iata_code(airport) }
    validate_nonstop_selection
  end

  def required_params_present?
    
  end

  # validate airport code
  def validate_airport_iata_code(airport_code)
    # convert to upcase
    Airport.find(airport_iata_code: airport_code)
  end

  def validate_date
    error_messages = []
    valid_date_pattern = /[0-9]{4}-[0-9]{2}-[0-9]{2}/ # YYYY-MM-DD
    today = Date.today
    max_date = today + 365
    # Check for valid date pattern (YYYY-MM-DD) first as
    # month, day without leading zeros  ex: "2018-9-5" is
    # considered valid in Date.strptime.
    # but API needs "2018-09-05" to process
    # external API calls.
    if valid_date_pattern.match?(@date)
      begin
        converted_date = Date.strptime(@date, '%Y-%m-%d')
        unless converted_date.between?(today, max_date)
          error_messages.push(ErrorMessages::INVALID_DATE_RANGE )
        end
      rescue ArgumentError => error
          error_messages.push(error.message.capitalize)
      end
    else
      error_messages.push(ErrorMessages::INVALID_DATE_FORMAT)
    end
    return error_messages
  end

  def validate_nonstop_selection
    # check if nonstop is 1 or 0
    # set default of 0
  end




end
