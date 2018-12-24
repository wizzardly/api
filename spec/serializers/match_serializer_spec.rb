# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  created_at  :datetime         not null
#  finished_at :datetime
#  id          :bigint(8)        not null, primary key
#  paused_at   :datetime
#  started_at  :datetime
#  status      :integer          default("pending")
#  updated_at  :datetime         not null
#

require "rails_helper"

RSpec.describe MatchSerializer, type: :serializer do
  let(:record) { create :match }
  let(:example_serializer) { described_class.new(record) }

  it { expect(described_class <= ApplicationSerializer).to be_truthy }

  describe ".attributes" do
    subject { example_serializer.attributes.map(&:first) }

    let(:expected_attributes) { %i[id status started_at paused_at finished_at] }

    it { is_expected.to eq expected_attributes }
  end
end
