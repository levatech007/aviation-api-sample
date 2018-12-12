class App
  require 'securerandom'
  require './lib/generateapikey.rb'

  route 'apikey' do |r|
    r.on 'generate' do
      r.is do
        r.get do          
          {POST: "/api/apikey/generate will generate an api key"}
        end
        # POST api/apikey/generate to generate new api key
        r.post do
          if r.params['email']
            email = r.params['email']
            GenerateApiKey.new(email).generate_key() #generates api key and emails to user
          else
           { error: "There was an error"}
          end
        end
      end
    end
  end
end
