class ParamValidations
  require 'date'

  def validate_destinations_request_params(airport_code)
    @airport = airport_code
    # validate apirport code
    DataValidations.new.valid_airport_iata_code?(@airport)
  end

  def validate_flight_request_params(request_params)
    @request_params  = request_params
    @date            = request_params[:date]
    @nonstop         = request_params[:nonstop]
    @@airport_params = %i[from to]
    @missing_params  = []
    @error_messages  = []
    # validate all and return messages:

    # validate date, add error message if invalid date
    # check that both from, to keys are present; if key is not present, add to missing_params
    # if airport key is present, validate airport code
    # if there are no errors, nonstop selection will be checked
    validate_request_date
    validate_airport_params
    validate_nonstop_selection if  @error_messages.empty? || @missing_params.empty?
    format_validation_response
  end

  def validate_request_date
    # check that :date is present,
    # validate if :date , else add to missing_params array
    if @request_params.key?(:date)
      date_validation = DataValidations.new.validate_date(@date)
      @error_messages.push(date_validation[:error_messages]) if date_validation[:errors]
    else
      @missing_params.push(:date.to_s)
    end
  end

  def validate_airport_params
    @@airport_params.each do |key|
      if @request_params.key? key
        airport_code = @request_params[key]
        unless DataValidations.new.valid_airport_iata_code?(airport_code)
          @error_messages.push("#{ErrorMessages::INVALID_AIRPORT_CODE}#{ key.to_s }")
        end
      else
        @missing_params.push(key.to_s)
      end
    end
  end

  def validate_nonstop_selection
    # check if nonstop is 1 or 0
    # if missing, set default of 0 and add to @request_params
      if @request_params.key?(:nonstop)
        # check if key is 1 or 0

      else
        # add nonstop default value to @request_params
      end
  end

  def format_validation_response
    errors = @error_messages.any? || @missing_params.any?
    # create a string from missing params and add to error_messages
    if @missing_params.any?
      missing_params_str = @missing_params.join(', ')
      missing_params_error = "#{ErrorMessages::MISSING_PARAMS}#{missing_params_str}"
      @error_messages.push(missing_params_error)
    end
    response_message = errors ? @error_messages.flatten : @request_params
    return { errors: errors, response: response_message }
  end


end
