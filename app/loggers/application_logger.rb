# frozen_string_literal: true

class ApplicationLogger < ActiveSupport::LogSubscriber
  LOGGABLE_BACKTRACE_LENGTH = 4

  protected

  def loggable_error(error)
    { error_message: error.message, error_backtrace: loggable_backtrace(error) }
  rescue StandardError
    {}
  end

  private

  def loggable_backtrace(error)
    error.backtrace.first(LOGGABLE_BACKTRACE_LENGTH).join("\n")
  rescue StandardError
    nil
  end
end
