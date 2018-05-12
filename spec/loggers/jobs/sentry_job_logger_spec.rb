# frozen_string_literal: true

require "rails_helper"

RSpec.describe SentryJobLogger, type: :logger do
  let(:instance) { described_class.new }
  let(:event) { instance_double(ActiveSupport::Notifications::Event) }
  let(:payload) do
    {}
  end

  before { allow(event).to receive(:payload).and_return(payload) }

  it { expect(described_class <= ApplicationLogger).to be_truthy }

  describe "#deserialization_error" do
    let(:event_hash) { Hash[*Faker::Lorem.unique.words(4)] }
    let(:deserialization_error) { instance_double(ActiveJob::DeserializationError) }
    let(:payload) do
      { event_hash: event_hash, deserialization_error: deserialization_error }
    end

    let(:loggable_error) { Hash[*Faker::Lorem.unique.words(4)] }
    let(:expected_arguments) do
      { entry: :deserialization_error, event_hash: event_hash }.merge(loggable_error)
    end

    before do
      allow(instance).to receive(:loggable_error).and_return(loggable_error)
    end

    it "fatal logs with the expected parameters" do
      allow(Rails.logger).to receive(:fatal) do |&block|
        expect(block.yield).to eq expected_arguments
      end

      instance.deserialization_error(event)
    end
  end

  describe "#sentry_disabled" do
    let(:event_hash) { Hash[*Faker::Lorem.unique.words(4)] }
    let(:payload) do
      { event_hash: event_hash }
    end

    let(:expected_arguments) do
      { entry: :sentry_disabled, event_hash: event_hash }
    end

    it "info logs with the expected parameters" do
      allow(Rails.logger).to receive(:info) do |&block|
        expect(block.yield).to eq expected_arguments
      end

      instance.sentry_disabled(event)
    end
  end

  describe "#sent_to_sentry" do
    let(:expected_arguments) do
      { entry: :sent_to_sentry }
    end

    it "info logs with the expected parameters" do
      allow(Rails.logger).to receive(:info) do |&block|
        expect(block.yield).to eq expected_arguments
      end

      instance.sent_to_sentry(event)
    end
  end
end
