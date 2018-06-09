# frozen_string_literal: true

class ApplicationCache
  BASE_CACHE_KEY = "ApplicationCache"

  class CacheRollback < StandardError; end

  class << self
    def flush_entire_cache
      delete_keys BASE_CACHE_KEY, __method__
    end

    def clear_all
      delete_keys key, __method__
    end

    def get(id)
      new(id).get
    end

    def clear(id)
      new(id).clear
    end

    def key
      "#{BASE_CACHE_KEY}:#{name}"
    end

    private

    def delete_keys(keyspace, method)
      redis = Redis.new
      keys = redis.keys("#{keyspace}*")
      redis.del(*keys) if keys.any?

      ActiveSupport::Notifications.instrument "#{method}.application_cache.info", keyspace: keyspace

      keys
    end
  end

  attr_reader :id

  def initialize(id)
    @id = id
    @redis = Redis.new
  end

  def get
    value = fetch_value
    parse(value) if value.present?
  end

  def clear
    instrument :info, __method__
    redis.hdel(key, id) == 1
  end

  protected

  def parse(cached_value)
    # This class expects the cached_values to be JSON representations of a hash which can be
    # parsed back into true hashes. Descendant classes should only need to override this method
    # if that ends up not being the case.
    JSON.parse(cached_value)
  rescue StandardError
    cached_value
  end

  def generate_value!
    # If the value you are generating is expensive to compute and comes out to be `nil`, you should
    # cache that nil value here so future calls to the cache do not recompute the value.
    #
    # However, if it is your desire to NOT store the nil value and to have a future call attempt to
    # generate the value again, simply raise any error from this method and no value will be
    # committed to the cache.
    #
    # This raises NotImplementedError which is not a descendant of StandardError and is intended
    # to be a noisy warning to developers that they built the class incorrectly. Overriding this
    # method is required for the cache to be even a little useful.
    raise NotImplementedError
  end

  private

  delegate :key, to: :class

  attr_reader :redis

  def instrument(criticality, event, **data)
    ActiveSupport::Notifications.instrument "#{event}.application_cache.#{criticality}", data.merge(key: key, id: id)
  end

  def fetch_value
    if cached?
      instrument :debug, :hit
      return current_value
    end

    instrument :info, :miss

    begin
      generate_and_cache_value
    rescue StandardError => error
      instrument :error, :error_generating_value, error: error
      nil
    end
  end

  def cached?
    redis.hexists(key, id)
  end

  def current_value
    redis.hget(key, id)
  end

  def generate_and_cache_value
    generated_value = generate_value!
    redis.hset(key, id, generated_value)
    instrument :info, __method__
    generated_value
  rescue CacheRollback => error
    instrument :error, :rollback, error: error
    nil
  end
end
