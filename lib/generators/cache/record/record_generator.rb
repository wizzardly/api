# frozen_string_literal: true

module Cache
  class RecordGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    check_class_collision suffix: "RecordCache"

    hook_for :test_framework

    def create_record_cache_file
      template "record_cache.rb", File.join("app/caches/", class_path, "#{file_name}_cache.rb")
    end
  end
end
