# sets and checks for rate limit for individual API keys in DB
class RateLimiting
  require 'redis'
  TIME_WINDOW = 15 * 60 # for testing purposes, time window is 15 min
  MAX_REQUESTS = 10

  def rate_limit_not_exceeded?(api_key)
    redis = Redis.new
    key = "count:#{api_key}"
    count = redis.get(key)

    unless count
      redis.set(key, 0)
      redis.expire(key, TIME_WINDOW)
    end

    return false if count.to_i > MAX_REQUESTS

    redis.incr(key)
    true
  end
end
