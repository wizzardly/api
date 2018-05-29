# frozen_string_literal: true

require "rails/generators/active_record/model/model_generator"

module Model
  class ModelGenerator < Rails::Generators::ModelGenerator
    class_option :cache, type: :boolean, default: true

    hook_for :cache
  end
end
