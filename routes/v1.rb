class App
  require './lib/gettoken.rb'
  require 'rest-client'

  route 'v1.0' do |r|
    r.on 'welcome' do
      @greeting = 'Welcome to Version 1' #test

      r.get "flights" do

        #GET TOKEN FIRST
        @lh_token = GetToken.new
        @token = @lh_token.get_lh_token()
        @access_token = @token['access_token']
        @token_type = @token['token_type'].capitalize
        #make request to LH API
        auth = "#{ @token_type } #{ @access_token }"
        url = "https://api.lufthansa.com/v1/operations/schedules/FRA/SFO/2018-12-25?directFlights=1" #hardcoded params for now
        response = RestClient::Request.execute(
        method: :get,
        url: url,
        headers: { Authorization: auth, Accept: "application/json" }
        )
        p(response)
        #currently only return LH token
        #next: GET request to LH API to retrieve flights between airports
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
