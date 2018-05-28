# frozen_string_literal: true

class LoggersGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  check_class_collision suffix: "Logger"

  hook_for :test_framework

  def create_logger_file
    template "logger.rb", File.join("app/loggers/", class_path, "#{file_name}_logger.rb")
  end
end
