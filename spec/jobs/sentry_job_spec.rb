# frozen_string_literal: true

require "rails_helper"

RSpec.describe SentryJob, type: :job do
  it { expect(described_class <= ApplicationJob).to be_truthy }

  describe "#perform" do
    subject(:sentry_client) { Raven }

    let(:sentry_enabled) { true }
    let(:event_hash) { Hash[*Faker::Lorem.words(4)] }
    let(:instance) { described_class.new event_hash }

    before do
      allow(Settings).to receive_message_chain(:sentry, :enable).and_return(sentry_enabled)
      allow(Raven).to receive(:send_event).and_call_original
    end

    context "when something goes wrong" do
      before do
        allow(instance).to receive(:deserialize_arguments_if_needed) do
          # Cause a DeserializationError
          ActiveJob::Arguments.deserialize([ Class ])
        end

        instance.perform_now
      end

      it_behaves_like "an instrumented event", "deserialization_error.sentry_job.error" do
        let(:expected_data) do
          { event_hash: event_hash, error: an_instance_of(ActiveJob::DeserializationError) }
        end
      end

      it { is_expected.not_to have_received(:send_event) }
    end

    context "when nothing goes wrong" do
      before { instance.perform_now }

      context "when sentry is enabled" do
        it { is_expected.to have_received(:send_event).with(event_hash) }

        it_behaves_like "an instrumented event", "sent_to_sentry.sentry_job.info"
      end

      context "when sentry disabled" do
        let(:sentry_enabled) { false }

        it { is_expected.not_to have_received(:send_event) }

        it_behaves_like "an instrumented event", "sentry_disabled.sentry_job.debug" do
          let(:expected_data) do
            { event_hash: event_hash }
          end
        end
      end
    end
  end
end
