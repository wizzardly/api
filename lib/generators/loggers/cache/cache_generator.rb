# frozen_string_literal: true

module Loggers
  class CacheGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    check_class_collision suffix: "CacheLogger"

    hook_for :test_framework, as: "cache_logger"

    def create_blotter_file
      template "cache_logger.rb", File.join("app/loggers/caches/", class_path, "#{file_name}_cache_logger.rb")
    end
  end
end
