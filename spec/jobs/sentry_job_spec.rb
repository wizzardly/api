# frozen_string_literal: true

require "rails_helper"

RSpec.describe SentryJob, type: :job do
  it { expect(described_class <= ApplicationJob).to be_truthy }

  describe "#perform" do
    subject(:sentry_client) { Raven }

    let(:sentry_enabled) { true }
    let(:event_hash) { Hash[*Faker::Lorem.words(4)] }
    let(:instance) { described_class.new(event_hash) }

    before do
      allow(Settings).to receive_message_chain(:sentry, :enable).and_return(sentry_enabled)
      allow(Raven).to receive(:send_event).and_call_original
    end

    context "when something goes wrong" do
      let(:serialized) { instance.serialize }

      let(:event_hash) do
        { invalid_value: Class.new }
      end

      it "does not try and log an error if an error occurred" do
        expect { described_class.execute serialized }.to raise_error ActiveJob::SerializationError
        is_expected.not_to have_received(:send_event)
      end
    end

    context "when nothing goes wrong" do
      before { instance.perform_now }

      context "when sentry is enabled" do
        it { is_expected.to have_received(:send_event).with(event_hash) }
      end

      context "when sentry disabled" do
        let(:sentry_enabled) { false }

        it { is_expected.not_to have_received(:send_event) }
      end
    end
  end
end
