source "https://rubygems.org"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.1"

# Environment
gem "dotenv-rails", groups: %i[development test]

# Rails
gem "rails", "~> 5.2.1"

# Database
gem "pg", ">= 0.18", "< 2.0"

# Server
gem "puma", "~> 3.11"
gem "sidekiq"

# Monitoring
gem "sentry-raven"

# Authentication
gem "knock"

# Authorization
gem "pundit"

# Security
gem "rack-cors"

# Caching
gem "redis"

# Email
gem "roadie-rails"

# ActiveRecord Utilities
gem "active_model_serializers"
gem "strip_attributes"

# Utilities
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", ">= 1.1.0", require: false
gem "config"
gem "lograge"
gem "logstash-logger"
gem "spicerack", "~> 0.5.0"

# Security Patches
gem "ffi", ">= 1.9.24"

group :development, :test do
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "timecop"

  gem "pundit-matchers"
  gem "shoulda-matchers", git: "https://github.com/thoughtbot/shoulda-matchers.git", branch: "rails-5"

  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "pry-rails"
  gem "pry-byebug"

  gem "rubocop", require: false
  gem "rubocop-rspec"
  gem "simplecov"
  gem "rspice"
end

group :development do
  gem "annotate"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-commands-rspec"
  gem "spring-watcher-listen", "~> 2.0.0"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
