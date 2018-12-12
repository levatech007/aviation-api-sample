class App
  require './lib/gettoken.rb'
  require 'rest-client'

  route 'v1.0' do |r|
    r.on 'welcome' do
      @greeting = 'Welcome to Version 1' #test

      r.get "flights" do

        #GET TOKEN FIRST
        @lh_token = GetToken.new.get_lh_token()
        @access_token = @lh_token['access_token']
        @token_type = @lh_token['token_type'].capitalize
        #make request to LH API
        auth = "#{ @token_type } #{ @access_token }" #format: "Bearer kfu894usdbj"
        url = "https://api.lufthansa.com/v1/operations/schedules/FRA/SFO/2018-12-25?directFlights=1" #hardcoded params for now
        response = RestClient::Request.execute(
        method: :get,
        url: url,
        headers: { Authorization: auth, Accept: "application/json" }
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
