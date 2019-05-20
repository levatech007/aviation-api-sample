# request needed tokens for 3rd party API calls
class GetToken
  require 'redis'
  require 'date'
  require 'rest-client'
  LH_TOKEN_URL = 'https://api.lufthansa.com/v1/oauth/token'.freeze

  def obtain_lh_token
    # Lufthansa API
    data = {
      client_id:     ENV['LH_CLIENT_ID'],
      client_secret: ENV['LH_SECRET'],
      grant_type:    'client_credentials'
    }
    response = RestClient::Request.execute(
                                            method:   :post,
                                            url:      LH_TOKEN_URL,
                                            payload:  data,
                                            headers:  { content_type: 'application/x-www-form-urlencoded' }
                                          )
    lh_token = response.to_s
    # key format for Redis: lhtoken:week00:day0 => week is week number, day is 1-7 (mon-sun) calendar day
    # set to expire in 48 hrs (keep one as backup)
    # store token in redis
    redis = Redis.new
    today = Date.today
    key = "lhtoken:week#{ today.cweek }:day#{ today.cwday }"
    expire = 60 * 60 * 48
    unless redis.exists(key)
      redis.set(key, lh_token)
      redis.expire(key, expire)
    end
  end
end
