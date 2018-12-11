class App
  require 'rest-client'

  route 'v1.0' do |r|
    r.on 'welcome' do
      @greeting = 'Welcome to Version 1'

      # test routes GET /welcome/world request
      r.get "flights" do
        #GET request to LH API
        #GET TOKEN FIRST
        data = { client_id: ENV['LH_CLIENT_ID'], client_secret: ENV['LH_SECRET'], grant_type: "client_credentials" }
        p(data)
        response = RestClient::Request.execute(
        method: :post,
        url: "https://api.lufthansa.com/v1/oauth/token",
        payload: data,
        headers: { content_type: 'application/x-www-form-urlencoded' }
        )
      end
      # /hello request
      r.is do
        # GET /hello request
        r.get do
          "#{@greeting}!"
        end
      end
    end
  end
end
