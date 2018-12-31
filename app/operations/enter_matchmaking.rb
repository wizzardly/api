# frozen_string_literal: true

class EnterMatchmaking < ApplicationOperation
  def execute
    state.redis.sadd(ApplicationConstants::MATCHMAKING_SET_KEY, state.user.id)
  end
end
