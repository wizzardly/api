# frozen_string_literal: true

RSpec.shared_examples_for "a surveiled event" do |expected_event|
  subject { described_class }

  let(:expected_data) { nil }
  let(:expected_args) do
    [ expected_event ].tap { |args| args.push(**expected_data) if expected_data.present? }
  end

  before { allow(described_class).to receive(:surveil).and_call_original }

  it { is_expected.to have_received(:surveil).with(*expected_args) }
end
