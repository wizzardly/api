# frozen_string_literal: true

class MatchmakingController < ApplicationController
  before_action :authenticate_user
  skip_after_action :verify_authorized, only: :status

  def status
    render json: { in_matchmaking: redis.sismember(ApplicationConstants::MATCHMAKING_SET_KEY, current_user.id) }
  end
end
