class GenerateApiKey
  require 'securerandom'
  require './lib/sendapikeyemail.rb'

  def initialize(email)
    @email = email
  end

  def generate_key
    @api_key = "api_v1_#{SecureRandom.urlsafe_base64}"
    @rpd = 50 #request per day: set 50 as default for now
    @apikey = Apikey.new(
      api_key: @api_key,
      api_rpd: @rpd,
      email: @email
    )
    api_key = @api_key
    email = @email
    if @apikey.save
      @send_email = SendApiKeyEmail.new(email, api_key).send_email()
      return { status: "Created user" }
    end
  end

end
