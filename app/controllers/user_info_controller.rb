# frozen_string_literal: true

class UserInfoController < ApplicationController
  before_action :authenticate_user

  def show
    authorize current_user

    render json: UserCache.get(current_user.id)
  end
end
