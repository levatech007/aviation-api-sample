module ErrorMessages
  # API Key related error messages
  QUERY_INVALID     = "No api key present. Make sure you've included your correct api key."
  API_KEY_INVALID   = 'The api key provided is not valid.'
  EMAIL_INVALID     = 'The email provided is not valid.'
  LIMIT_EXCEEDED    = 'You have exceeded your daily request limit.'
  EMAIL_NOT_PRESENT = 'No email is present in the request.'

  # API request error messages
  CHECK_SPELLING    = 'Please check your spelling and formatting of the request.'
  MISSING_PARAMS    = 'Missing the following required params: '

  # General errors
  GENERAL_ERROR     = 'Something went wrong. Please try again later.'

  # Date errors
  INVALID_DATE_FORMAT = 'Date format is invalid'
  INVALID_DATE_RANGE  = 'Date is out of available range'

  # Airport code errors
  INVALID_AIRPORT_CODE = 'Invalid airport code for: '
  DEPARTURE_INVALID = 'The departure airport code is invalid.'
  ARRIVAL_INVALID   = 'The arrival airport code is invalid.'

  BAD_REQUEST = "Bad request"
end
