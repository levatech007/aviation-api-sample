# request needed tokens for 3rd party API calls
class GetToken
  require 'rest-client'
  # plugin :halt
  LH_TOKEN_URL = 'https://api.lufthansa.com/v1/oauth/token'.freeze

  def obtain_lh_token
    # Lufthansa API
    data = {
      client_id: ENV['LH_CLIENT_ID'],
      client_secret: ENV['LH_SECRET'],
      grant_type: 'client_credentials'
    }
    response = RestClient::Request.execute(
      method: :post,
      url: LH_TOKEN_URL,
      payload: data,
      headers: { content_type: 'application/x-www-form-urlencoded' }
    )
    JSON.parse(response)
  end
end
