# frozen_string_literal: true

RSpec.shared_context "with application logger" do
  let(:instance) { described_class.new }
  let(:event) { instance_double(ActiveSupport::Notifications::Event) }
  let(:payload) do
    {}
  end

  before { allow(event).to receive(:payload).and_return(payload) }
end
