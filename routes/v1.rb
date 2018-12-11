class App
  require './lib/gettoken.rb'

  route 'v1.0' do |r|
    r.on 'welcome' do
      @greeting = 'Welcome to Version 1' #test

      r.get "flights" do
        #GET request to LH API
        #GET TOKEN FIRST
        @lh_token = GetToken.new
        @lh_token.get_lh_token()
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
