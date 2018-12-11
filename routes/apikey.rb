class App
  require 'securerandom'
  require 'mail'
  #plugin :mailer, content_type: "text/html"

  route 'apikey' do |r|
    r.on 'generate' do
      r.is do
        r.get do

        end
        # POST api/apikey/generate to generate new api key
        r.post do
          @key = "api_v1_#{SecureRandom.urlsafe_base64}"
          api_key = @key
          @rpd = 50 #requet per day: set 50 as default for now
          @email = r.params['email']
          @apikey = Apikey.new(
            api_key: @key,
            api_rpd: @rpd,
            email: @email
          )
          if @apikey.save
            p(@key)
            p(@apikey)
            mail = Mail.new do
              from ENV['GMAIL_USERNAME']
              to r.params['email']
              subject "Here is your API key"
              body "Your API key is '#{api_key}'"
            end
            mail.deliver

            { status: "Created user", api_key: @key, api_rpd: @rpd, email: @email }
          end

        end
      end
    end
  end
end
