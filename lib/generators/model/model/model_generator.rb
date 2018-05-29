# frozen_string_literal: true

require "rails/generators/active_record/model/model_generator"

module Model
  class ModelGenerator < Rails::Generators::JobGenerator
    class_option :record_cache, type: :boolean, default: true

    hook_for :record_cache
  end
end
