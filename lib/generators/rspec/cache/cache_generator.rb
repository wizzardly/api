# frozen_string_literal: true

module Rspec
  class CacheGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    check_class_collision suffix: "CacheSpec"

    def create_spec_file
      template "cache_spec.rb", File.join("spec/caches/", class_path, "#{file_name}_cache_spec.rb")
    end
  end
end
