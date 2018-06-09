class ApplicationLogger
  def call(name, started, finished, _unique_id, payload)
    Rails.logger.public_send(criticality) do
      { event: name.chomp(".#{criticality}"), started: started, finished: finished }.compact.merge(payload)
    end
  end

  private

  def criticality
    @criticality ||= self.class.name.chomp("Logger").downcase.to_sym
  end
end

class FatalLogger < ApplicationLogger; end
class ErrorLogger < ApplicationLogger; end
class WarnLogger < ApplicationLogger; end
class InfoLogger < ApplicationLogger; end
class DebugLogger < ApplicationLogger; end

ActiveSupport::Notifications.subscribe(%r{\.fatal$}, FatalLogger.new)
ActiveSupport::Notifications.subscribe(%r{\.error$}, ErrorLogger.new)
ActiveSupport::Notifications.subscribe(%r{\.warn$}, WarnLogger.new)
ActiveSupport::Notifications.subscribe(%r{\.info$}, InfoLogger.new)
ActiveSupport::Notifications.subscribe(%r{\.debug$}, DebugLogger.new)
