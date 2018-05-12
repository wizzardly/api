# frozen_string_literal: true

class SentryJob < ApplicationJob
  queue_as :very_high

  rescue_from ActiveJob::DeserializationError do |deserialization_error|
    # If not rescued, this error causes an infinite loop.
    ActiveSupport::Notifications.instrument(
      "deserialization_error.sentry_job",
      event_hash: arguments[0],
      deserialization_error: deserialization_error,
    )
  end

  def perform(event_hash)
    unless Settings.sentry.enable
      ActiveSupport::Notifications.instrument "sentry_disabled.sentry_job", event_hash: event_hash
      return
    end

    Raven.send_event(event_hash)
    ActiveSupport::Notifications.instrument "sent_to_sentry.sentry_job"
  end
end
