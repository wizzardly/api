# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserSerializer, type: :serializer do
  let(:record) { create :user }
  let(:example_serializer) { described_class.new(record) }

  it { expect(described_class <= ApplicationSerializer).to be_truthy }

  describe ".serializable_hash" do
    subject { example_serializer.serializable_hash }

    let(:expected_hash) do
      { name: record.name,
        first_name: record.first_name,
        last_name: record.last_name,
        initials: record.initials,
        email: record.email }
    end

    it { is_expected.to eq expected_hash }
  end
end
