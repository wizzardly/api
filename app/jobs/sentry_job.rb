# frozen_string_literal: true

class SentryJob < ApplicationJob
  queue_as :very_high

  rescue_from ActiveJob::DeserializationError do |exception|
    # If not rescued, this error causes an infinite loop.
    error :deserialization_error, event_hash: arguments[0], exception: exception
  end

  def perform(event_hash)
    debug :sentry_disabled, event_hash: event_hash and return unless Settings.sentry.enable

    surveil(:send_to_sentry) { Raven.send_event(event_hash) }
  end
end
