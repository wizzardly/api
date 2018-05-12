# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationLogger, type: :logger do
  subject(:described_method) { test_instance.call error }

  let(:test_instance) { test_class.new }

  describe ".loggable_backtrace" do
    let(:test_class) do
      Class.new(described_class) do
        def call(object)
          loggable_backtrace(object)
        end
      end
    end

    let(:error) { instance_double(StandardError) }
    let(:backtrace) { Faker::Lorem.words(10) }

    context "when something goes wrong accessing the backtrace" do
      before { allow(error).to receive(:backtrace).and_raise StandardError }

      it { is_expected.to be_nil }
    end

    context "when nothing goes wrong" do
      before { allow(error).to receive(:backtrace).and_return(backtrace) }

      context "without a backtrace" do
        let(:backtrace) { nil }

        it { is_expected.to be_nil }
      end

      context "with an invalid backtrace" do
        let(:backtrace) { Faker::Lorem.word }

        it { is_expected.to be_nil }
      end

      context "with a backtrace" do
        it { is_expected.to eq backtrace.first(ApplicationLogger::LOGGABLE_BACKTRACE_LENGTH).join("\n") }
      end
    end
  end

  describe ".loggable_error" do
    let(:test_class) do
      Class.new(described_class) do
        def call(object)
          loggable_error(object)
        end
      end
    end

    let(:error) { instance_double(StandardError) }

    context "with a malformed error" do
      let(:error) { Faker::Lorem.word }

      it { is_expected.to eq({}) }
    end

    context "when given an well formed error" do
      let(:message) { Faker::Lorem.unique.sentence }
      let(:backtrace) { Faker::Lorem.words(10) }
      let(:loggable_backtrace) { Faker::Lorem.unique.sentence }

      before do
        allow(error).to receive(:message).and_return(message)
        allow(error).to receive(:backtrace).and_return(backtrace)
        allow(test_instance).to receive(:loggable_backtrace).and_return(loggable_backtrace)
      end

      it { is_expected.to eq error_message: message, error_backtrace: loggable_backtrace }
    end
  end
end
