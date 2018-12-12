class App
  require './lib/gettoken.rb'
  require './lib/validateapikey.rb'
  require 'rest-client'
  plugin :halt

  route 'v1.0' do |r|
    r.on 'welcome' do
      r.get "flights" do
        key = r.params['api_key']
        if key
          if ValidateApiKey.new(key).validate_key() == 1 #returns 1 or 0, does not work without ==
            @lh_token = GetToken.new.get_lh_token()
            @access_token = @lh_token['access_token']
            @token_type = @lh_token['token_type'].capitalize

            auth = "#{ @token_type } #{ @access_token }" #format: "Bearer kfu894usdbj"
            url = "https://api.lufthansa.com/v1/operations/schedules/FRA/SFO/2018-12-25?directFlights=1" #hardcoded params for now
            response = RestClient::Request.execute(
            method: :get,
            url: url,
            headers: { Authorization: auth, Accept: "application/json" }
            )
          else
            r.halt(401, { status: 401, error: "Unauthorized", message: "Api key is invalid"})
          end
        else
          r.halt(403, { status: 403, error: "Forbidden", message: "No api key present"})
        end
      end
    end
  end
end
