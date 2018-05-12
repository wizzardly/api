# frozen_string_literal: true

require "rails_helper"

RSpec.describe EngineeringMailer, type: :mailer do
  it { expect(described_class <= ApplicationMailer).to be_truthy }
  it { expect(described_class._layout).to eq "mailer" }

  describe "#sentry_failure" do
    subject(:mail) { described_class.sentry_failure(event).deliver_now }

    let(:to_email) { Faker::Internet.email }
    let(:event) do
      Hash[*Faker::Lorem.unique.words(8)]
    end

    before do
      allow(Settings).to receive_message_chain(:application, :engineering_email).and_return(to_email)
    end

    it "sends the expected email" do
      expect(mail.to).to eq [ to_email ]
      expect(mail.from).to eq [ t("email.sender") ]
      expect(mail.subject).to eq t("engineering_mailer.sentry_failure.subject")

      expect(mail.body).to match t("engineering_mailer.sentry_failure.title")
      expect(mail.body).to match JSON.pretty_generate(event, object_nl: "\n")
    end
  end
end
