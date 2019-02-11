module ErrorMessages
  # API Key related error messages
  QUERY_INVALID     = "No api key present. Make sure you've included your correct api key."
  API_KEY_INVALID   = 'The api key provided is not valid.'
  EMAIL_INVALID     = 'The email provided is not valid.'
  LIMIT_EXCEEDED    = 'You have exceeded your daily request limit.'
  EMAIL_NOT_PRESENT = 'No email is present in the request.'

  # API request error messages
  CHECK_SPELLING    = 'Please check your spelling and formatting of the request.'

  # General errors
  GENERAL_ERROR     = 'Something went wrong. Please try again later.'

  # Date errors
  LH_DATE_INVALID   = 'Date is not valid. Please check your date format ("YYYY-MM-DD").'
  PAST_DATE         = 'Date is in the past.'

  # Airport code errors
  DEPARTURE_INVALID = 'The departure airport code is invalid.'
  ARRIVAL_INVALID   = 'The arrival airport code is invalid.'
end
