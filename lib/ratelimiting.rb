class RateLimiting
  require 'redis'
  TIME_WINDOW = 15 * 60 #for testing purposes, time window is 15 min
  MAX_REQUESTS = 5

  def rateLimitNotExceeded(api_key)
    redis = Redis.new
    key = "count:#{api_key}"
    count = redis.get(key)

    unless count
      redis.set(key, 0)
      redis.expire(key, TIME_WINDOW)
    end

    if count.to_i >= MAX_REQUESTS
      return false
    end

    redis.incr(key)
    true
   end
end
