# frozen_string_literal: true

Rails.application.configure do
  puts "WUT"
  config.lograge.base_controller_class = "ActionController::API"
  config.lograge.enabled = true
  # config.lograge.formatter = Lograge::Formatters::Logstash.new
  config.lograge.custom_options = lambda do |event|
    exceptions = %w[controller action format id]
    { params: event.payload[:params].except(*exceptions) }
  end
end
