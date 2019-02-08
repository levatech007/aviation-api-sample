# generates a new api key for user
class GenerateApiKey
  require 'securerandom'
  require './lib/sendapikeyemail.rb'

  def initialize(email)
    @email = email
  end

  def generate_key
    @generated_key = "api_v1_#{SecureRandom.urlsafe_base64}"
    @rpd = 50 # request per day: functionality not working yet
    @api_key = Apikey.new(
                            api_key: @generated_key,
                            api_rpd: @rpd,
                            email:   @email
                          )
    api_key = @generated_key
    email   = @email
    if @api_key.save
      SendApiKeyEmail.new(email, api_key).send_email
      return { message: 'Please check your email for your new API key' }
    else
      return { message: 'Something went wrong' }
    end
  end
end
