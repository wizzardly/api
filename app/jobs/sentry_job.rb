# frozen_string_literal: true

class SentryJob < ApplicationJob
  queue_as :very_high

  rescue_from ActiveJob::DeserializationError do |error|
    # If not rescued, this error causes an infinite loop.
    ActiveSupport::Notifications.instrument(
      "deserialization_error.sentry_job.error",
      event_hash: arguments[0],
      error: error,
    )
  end

  def perform(event_hash)
    unless Settings.sentry.enable
      ActiveSupport::Notifications.instrument "sentry_disabled.sentry_job.debug", event_hash: event_hash
      return
    end

    Raven.send_event(event_hash)
    ActiveSupport::Notifications.instrument "sent_to_sentry.sentry_job.info"
  end
end
