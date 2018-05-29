# frozen_string_literal: true

class CacheGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  check_class_collision suffix: "Cache"

  hook_for :test_framework

  def create_cache_file
    template "cache.rb", File.join("app/caches/", class_path, "#{file_name}_cache.rb")
  end
end
