# frozen_string_literal: true

module Loggers
  class JobGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    check_class_collision suffix: "JobLogger"

    hook_for :test_framework, as: "job_logger"

    def create_logger_file
      template "job_logger.rb", File.join("app/loggers/jobs/", class_path, "#{file_name}_job_logger.rb")
    end
  end
end
