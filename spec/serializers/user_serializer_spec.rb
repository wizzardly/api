# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  created_at      :datetime         not null
#  email           :string           not null
#  first_name      :string           not null
#  id              :bigint(8)        not null, primary key
#  last_name       :string           not null
#  password_digest :string           not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#


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
