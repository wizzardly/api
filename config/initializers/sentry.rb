if Settings.sentry.enable
  Raven.configure do |config|
    config.dsn = Settings.sentry.dsn
    config.async = ->(event) { SentryJob.perform_later(event.to_hash) }
    config.transport_failure_callback = ->(event) { EngineeringMailer.sentry_failure(event).deliver_later }
  end
end
