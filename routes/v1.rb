class App

  route 'v1.0' do |r|
    r.on 'welcome' do
      @greeting = 'Welcome to Version 1'

      # test routes GET /welcome/world request
      r.get "world" do
        "#{@greeting}"
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
