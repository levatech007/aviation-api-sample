# General data validations
class DataValidations
  require 'date'

  @@today = Date.today
  @@max_date = @@today + 365
  @@valid_date_pattern = /[0-9]{4}-[0-9]{2}-[0-9]{2}/ # YYYY-MM-DD
  @@iata_code_pattern = /\w{3}/ # 3 alphanumeric characters

  def validate_date(date)
    @date = date
    @date_errors = []
    # Check for valid date pattern (YYYY-MM-DD) first as month, day without
    # leading zeros, ex.: "2018-9-5" is considered valid in Date.strptime.
    # but API needs "2018-09-05" to process external API calls.
    if @@valid_date_pattern.match?(@date)
      begin
        converted_date = Date.strptime(@date, '%Y-%m-%d')
        unless converted_date.between?(@@today, @@max_date)
          @date_errors.push(ErrorMessages::INVALID_DATE_RANGE)
        end
      rescue ArgumentError => error
        @date_errors.push(error.message.capitalize)
      end
    else
      @date_errors.push(ErrorMessages::INVALID_DATE_FORMAT)
    end

    return {
      errors: @date_errors.any?,
      error_messages: @date_errors
    }
  end

  def valid_airport_iata_code?(airport_code)
    @@iata_code_pattern.match?(airport_code) && Airport.find(airport_iata_code: airport_code.upcase)
  end

end
