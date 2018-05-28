# frozen_string_literal: true

module Rspec
  class JobLoggerGenerator < Rails::Generators::NamedBase
    source_root File.expand_path("templates", __dir__)

    check_class_collision suffix: "JobLoggerSpec"

    def create_spec_file
      template "job_logger_spec.rb", File.join("spec/loggers/jobs/", class_path, "#{file_name}_job_logger_spec.rb")
    end
  end
end
