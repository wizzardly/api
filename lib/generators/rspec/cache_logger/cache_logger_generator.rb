# frozen_string_literal: true

module Rspec
  class CacheLoggerGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    check_class_collision suffix: "CacheLoggerSpec"

    def create_spec_file
      template "cache_logger_spec.rb",
               File.join("spec/loggers/caches/", class_path, "#{file_name}_cache_logger_spec.rb")
    end
  end
end
