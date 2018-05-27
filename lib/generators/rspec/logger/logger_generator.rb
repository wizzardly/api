# frozen_string_literal: true

module Rspec
  class LoggerGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    check_class_collision suffix: "LoggerSpec"

    def create_spec_file
      template "logger_spec.rb", File.join("spec/loggers", class_path, "#{file_name}_logger_spec.rb")
    end
  end
end