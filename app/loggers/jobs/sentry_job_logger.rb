# frozen_string_literal: true

class SentryJobLogger < ApplicationLogger
  def deserialization_error(event)
    event_hash = event.payload[:event_hash]
    deserialization_error = event.payload[:deserialization_error]

    Rails.logger.tagged(%w[Error DeserializationError Sentry]) do
      Rails.logger.fatal do
        { entry: __method__, event_hash: event_hash }.merge(loggable_error(deserialization_error))
      end
    end
  end

  def sentry_disabled(event)
    Rails.logger.tagged(%w[Sentry]) { Rails.logger.info entry: __method__, event_hash: event.payload[:event_hash] }
  end

  def sent_to_sentry(_)
    Rails.logger.tagged(%w[Sentry]) { Rails.logger.info entry: __method__ }
  end
end
