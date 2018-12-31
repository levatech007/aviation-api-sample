# checks if the supplied API key exists in database
class ValidateApiKey
  
  def initialize(api_key)
    @api_key = api_key
  end

  def api_key_valid?
    return true if Apikey.find(api_key: @api_key)

    false
  end
end
