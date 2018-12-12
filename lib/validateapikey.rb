class ValidateApiKey
  def initialize(api_key)
    @api_key = api_key
  end

  def validate_key
    # check if the key is in db
    if Apikey.find(api_key: @api_key)
      return {result: "Access granted"}
    else
      return {result: "Key does not exist"}
    end 
  end
end
