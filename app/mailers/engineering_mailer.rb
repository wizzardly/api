# frozen_string_literal: true

class EngineeringMailer < ApplicationMailer
  def sentry_failure(event)
    @event = event

    mail(
      to: Settings.application.engineering_email,
      from: t("email.sender"),
      subject: t("engineering_mailer.sentry_failure.subject"),
    )
  end
end
