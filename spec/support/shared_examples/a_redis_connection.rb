# frozen_string_literal: true

RSpec.shared_examples_for "a redis connection" do
  it { is_expected.to include_module RedisConnection }

  describe "#redis" do
    it "returns a redis connection" do
      expect(subject.redis).to be_an_instance_of Redis # rubocop:disable RSpec/NamedSubject
    end
  end
end
