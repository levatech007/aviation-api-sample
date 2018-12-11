class App
  require 'securerandom'
  require './lib/apikeyemail.rb'

  route 'apikey' do |r|
    r.on 'generate' do
      r.is do
        r.get do
          {POST: "/api/apikey/generate will generate an api key"}
        end
        # POST api/apikey/generate to generate new api key
        r.post do
          @api_key = "api_v1_#{SecureRandom.urlsafe_base64}"
          @rpd = 50 #request per day: set 50 as default for now
          @email = r.params['email']
          @apikey = Apikey.new(
            api_key: @api_key,
            api_rpd: @rpd,
            email: @email
          )
          api_key = @api_key
          email = r.params['email']

          if @apikey.save
            @send_email = ApiKeyEmail.new(email, api_key)
            @send_email.send_email()

            { status: "Created user" }
          end

        end
      end
    end
  end
end
