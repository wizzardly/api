# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Knock::Authenticable
  include Pundit

  after_action :verify_authorized

  rescue_from Pundit::NotAuthorizedError, with: :user_forbidden

  private

  def user_forbidden
    render status: :forbidden, json: { message: t("pundit.user_forbidden") }
  end
end
