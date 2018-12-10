class App
  require 'securerandom'

  route 'apikey' do |r|
    r.on 'generate' do
      r.is do
        r.get do
          @key = "api_v1_#{SecureRandom.urlsafe_base64}"
          @rpd = 50 #set as default for now
          @apikey = Apikey.create(
            api_key: @key,
            api_rpd: @rpd
            )
          # @apikey.save
          # p(@apikey)
          { status: "Created user", api_key: @key }
        end

        r.post do

        end
      end
    end
  end
end
