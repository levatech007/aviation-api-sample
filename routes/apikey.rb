class App
  require 'securerandom'
  require './lib/generateapikey.rb'
  require 'uri'

  route 'apikey' do |r|
    r.on 'generate' do
      r.is do
        # POST api/apikey/generate to generate new api key
        r.post do
          to_email = r.params['email']
          p(to_email)
          if to_email && to_email.match(URI::MailTo::EMAIL_REGEXP).to_s != ''
            GenerateApiKey.new(to_email).generate_key # generates api key and emails it to user
          elsif to_email
            r.halt(400, message: ErrorMessages::EMAIL_INVALID)
          else
            r.halt(400, message: ErrorMessages::EMAIL_NOT_PRESENT)
          end
        end
      end
    end
  end
end
