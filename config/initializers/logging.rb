# frozen_string_literal: true

Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Logstash.new(type: :stdout)
  config.lograge.custom_options = lambda do |event|
    exceptions = %w[controller action format id]
    { params: event.payload[:params].except(*exceptions) }
  end
end
