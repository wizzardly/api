# frozen_string_literal: true

class MatchmakingController < ApplicationController
  before_action :authenticate_user
  skip_after_action :verify_authorized, only: :status

  def status
    render_matchmaking_status_json
  end

  def enter
    authorize Match.new, :create?

    EnterMatchmakingFlow.trigger(user: current_user) unless matchmaking?

    render_matchmaking_status_json
  end

  private

  def render_matchmaking_status_json
    render json: { in_matchmaking: matchmaking? }
  end

  def matchmaking?
    redis.sismember(ApplicationConstants::MATCHMAKING_SET_KEY, current_user.id)
  end
end
