# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WizzardlyApi
  class Application < Rails::Application
    config.load_defaults 5.2

    config.api_only = true

    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.deliver_later_queue_name = 'medium_low'

    config.generators do |g|
      g.assets false
      g.helper false
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
  end
end
