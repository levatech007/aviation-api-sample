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
          if to_email && to_email.match(URI::MailTo::EMAIL_REGEXP).to_s != ''
            GenerateApiKey.new(to_email).generate_key # generates api key and emails to user
          elsif to_email
            r.halt(400, { status: 400, error: 'Bad request', message: 'Email is not valid' })
          else
            r.halt(400, { status: 400, error: 'Bad request', message: 'No email present' })
          end
        end
      end
    end
  end
end
