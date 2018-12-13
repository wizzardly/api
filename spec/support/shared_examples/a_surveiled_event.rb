# frozen_string_literal: true

RSpec.shared_examples_for "a surveiled event" do |expected_event, expected_log_string|
  subject { ActiveSupport::Notifications }

  let(:expected_data) do
    {}
  end
  let(:expected_args_start) do
    [ "#{expected_event}_started.#{expected_log_string}", expected_data ]
  end
  let(:expected_args_finished) { [ "#{expected_event}_finished.#{expected_log_string}", {} ] }

  it { is_expected.to have_received(:instrument).with(*expected_args_start) }
  it { is_expected.to have_received(:instrument).with(*expected_args_finished) }
end
