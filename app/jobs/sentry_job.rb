# frozen_string_literal: true

class SentryJob < ApplicationJob
  queue_as :very_high

  rescue_from ActiveJob::DeserializationError do |deserialization_error|
    # If not rescued, this error causes an infinite loop.
    Rails.logger.tagged(%w[Error DeserializationError Sentry]) do
      Rails.logger.fatal(
        event: "failed_sending_event_to_sentry",
        error_details: arguments[0],
        error_message: deserialization_error.message,
        backtrace: deserialization_error.backtrace,
      )
    end
  end

  def perform(event_hash)
    Raven.send_event(event_hash) if Settings.sentry.enable

    Rails.logger.tagged(%w[Sentry]) { Rails.logger.info event: "reported_error_to_sentry" }
  end
end
