# frozen_string_literal: true

module RedisConnection
  extend ActiveSupport::Concern

  private

  def redis
    @redis ||= Redis.new
  end
end
