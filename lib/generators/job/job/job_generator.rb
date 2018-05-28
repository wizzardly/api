# frozen_string_literal: true

require "rails/generators/job/job_generator"

module Job
  class JobGenerator < Rails::Generators::JobGenerator
    class_option :loggers, type: :boolean, default: true

    hook_for :loggers
  end
end
