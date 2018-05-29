# frozen_string_literal: true

module Rspec
  class RecordCacheGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    check_class_collision suffix: "RecordCacheSpec"

    def create_spec_file
      template "record_cache_spec.rb", File.join("spec/caches/", class_path, "#{file_name}_cache_spec.rb")
    end
  end
end
