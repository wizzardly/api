# frozen_string_literal: true

Rails.application.configure do
  config.technologic.include_in_classes += %w[ApplicationJob ApplicationCache]
end
