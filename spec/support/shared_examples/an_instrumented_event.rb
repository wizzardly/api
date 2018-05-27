# frozen_string_literal: true

RSpec.shared_examples_for "an instrumented event" do |expected_event|
  subject { ActiveSupport::Notifications }

  let(:expected_data) { nil }
  let(:expected_args) do
    [ expected_event ].push(expected_data).compact
  end

  it { is_expected.to have_received(:instrument).with(*expected_args) }
end
