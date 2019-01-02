# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchPolicy, type: :policy do
  subject(:policy) { described_class.new(user, record) }

  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:match) }

  it { is_expected.to inherit_from ApplicationPolicy }

  context "without a user" do
    let(:user) { nil }

    it { is_expected.to forbid_action(:create) }
  end

  context "when the user has unfinished matches" do
    let(:user) { create :user }

    before { user.matches.create! }

    it { is_expected.to forbid_action(:create) }
  end

  context "when the user has no unfinished " do
    it { is_expected.to permit_action(:create) }
  end
end
