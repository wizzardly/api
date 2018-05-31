# frozen_string_literal: true

require "spec_helper"
require "simplecov"

SimpleCov.start do
  load_profile "rails"
  add_filter "lib/generators/"
end

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"

require "pundit/rspec"
require "strip_attributes/matchers"

ActiveJob::Base.queue_adapter = :test

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include ActiveJob::TestHelper
  config.include StripAttributes::Matchers
  config.include FactoryBot::Syntax::Methods
  config.include Rails.application.routes.url_helpers

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before do
    Redis.new.flushdb

    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    # https://github.com/rspec/rspec-mocks/issues/1121
    %i[debug info warn error fatal add].each do |method|
      allow(Rails.logger).to receive(method).and_call_original
    end

    allow(ActiveSupport::Notifications).to receive(:instrument).and_call_original
  end

  config.after do
    DatabaseCleaner.clean

    Timecop.return
  end

  config.filter_rails_from_backtrace!
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
