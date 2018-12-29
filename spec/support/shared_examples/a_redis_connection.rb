# frozen_string_literal: true

RSpec.shared_examples_for "a redis connection" do
  let(:redis) { subject.redis }

  it { is_expected.to include_module RedisConnection }

  let(:instance) { instance_double Redis }

  before { allow(Redis).to receive(:new).and_return(instance) }

  it "memoizes a redis connection" do
    expect(redis).to eq instance
    expect(Redis).to have_received(:new)
  end
end
