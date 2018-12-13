class ValidateApiKey
  def initialize(api_key)
    @api_key = api_key
  end

  def validate_key
    return true if Apikey.find(api_key: @api_key)
    false
  end
end
