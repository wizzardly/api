# frozen_string_literal: true

class ApplicationCacheLogger < ApplicationLogger
  def flush_entire_cache(event)
    log_keyspace_info __method__, event
  end

  def clear_all(event)
    log_keyspace_info __method__, event
  end

  def clear(event)
    log_cache_info __method__, event
  end

  def hit(event)
    log_cache_info __method__, event
  end

  def miss(event)
    log_cache_info __method__, event
  end

  def generate_and_cache_value(event)
    log_cache_info __method__, event
  end

  def error_generating_value(event)
    log_cache_error __method__, event, event.payload[:generation_error]
  end

  def rollback(event)
    log_cache_error __method__, event, event.payload[:rollback_error]
  end

  private

  def log_keyspace_info(entry, event)
    Rails.logger.info do
      { entry: entry, keyspace: event.payload[:keyspace] }
    end
  end

  def log_cache_info(entry, event)
    Rails.logger.info { cache_data_payload entry, event }
  end

  def log_cache_error(entry, event, error)
    Rails.logger.error { cache_data_payload(entry, event).merge(loggable_error(error)) }
  end

  def cache_data_payload(entry, event)
    { entry: entry, cache_key: event.payload[:cache_key], id: event.payload[:id] }
  end
end
