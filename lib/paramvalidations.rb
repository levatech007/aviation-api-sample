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
    # check that date is present, if yes, validate date, else add key to missing_params array
    # validate date, add error message if invalid date
    # check that both from, to keys are present; if key is not present, add to missing_params
    # if airport key is present, validate airport code
    # if there are no errors, nonstop selection will be checked
    validate_request_date
    validate_airport_params
    validate_nonstop_selection
    format_validation_response
  end

  def validate_request_date
    if @request_params.key?(:date)
      date_validation = DataValidations.new.validate_date(@date)
      @error_messages.push(date_validation[:error_messages]) if date_validation[:errors]
    else
      @missing_params.push(:date)
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
    # process only if there are no errors or missing params
    # check if nonstop is 1 or 0
    # if missing, set default of 0 and add to @request_params

  end

  def format_validation_response
    p(@error_messages)
    p(@missing_params)
    errors = @error_messages.any? || @missing_params.any?
    if errors
      p("There are errors")
    else
      p("There are no errors")
    end
    # {
    #   errors: T/F,
    #   messages: none if F
    # }
    # if there are errors: return {errors: t/f, messages: []}
    # else return request params with nonstop included
    # ErrorMessages::MISSING_PARAMS
  end


end
