# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  if Settings.sidekiq.enable_authentication
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(Settings.sidekiq.username),
      ) &
        ActiveSupport::SecurityUtils.secure_compare(
          ::Digest::SHA256.hexdigest(password),
          ::Digest::SHA256.hexdigest(Settings.sidekiq.password),
        )
    end
  end

  mount Sidekiq::Web => "/admin/sidekiq"

  post :user_token, to: "user_token#create"
  get :user_info, to: "user_info#show"

  get :matchmaking_status, to: "matchmaking#status"
end
