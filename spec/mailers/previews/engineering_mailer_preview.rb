# frozen_string_literal: true

class EngineeringMailerPreview < ActionMailer::Preview
  def sentry_failure
    EngineeringMailer.sentry_failure(Hash[*Faker::Lorem.unique.words(8)])
  end
end
