class App
  require './lib/gettoken.rb'
  require './lib/validateapikey.rb'
  require 'rest-client'

  route 'v1.0' do |r|
    r.on 'welcome' do
      @greeting = 'Welcome to Version 1' #test


      r.get "flights" do
        #validate api key

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
          #testing api key validation
          key = r.params['api_key']
          if key
            ValidateApiKey.new(key).validate_key()
          else
            {result: "Please send your api key with request"}
          end
        end
      end
    end
  end
end
