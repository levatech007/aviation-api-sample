class GetToken
  require 'rest-client'

  def get_lh_token #Lufthansa API
    data = {
      client_id: ENV['LH_CLIENT_ID'],
      client_secret: ENV['LH_SECRET'],
      grant_type: "client_credentials"
    }
    response = RestClient::Request.execute(
    method: :post,
    url: "https://api.lufthansa.com/v1/oauth/token",
    payload: data,
    headers: { content_type: 'application/x-www-form-urlencoded' }
    )
  end

end
