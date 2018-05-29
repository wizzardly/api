# frozen_string_literal: true

module Cache
  class ModelGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    check_class_collision suffix: "ModelCache"

    hook_for :test_framework, as: "model_cache"

    def create_model_cache_file
      template "model_cache.rb", File.join("app/caches/", class_path, "#{file_name}_cache.rb")
    end
  end
end
