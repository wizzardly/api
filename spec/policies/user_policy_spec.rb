# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserPolicy, type: :policy do
  subject(:policy) { described_class.new(user, record) }

  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:user) }

  it { is_expected.to inherit_from ApplicationPolicy }

  context "without a user" do
    let(:user) { nil }

    it { is_expected.to forbid_action(:show) }
  end

  context "when the user is different from the record" do
    it { is_expected.to forbid_action(:show) }
  end

  context "when the user and record are the same" do
    let(:record) { user }

    it { is_expected.to permit_action(:show) }
  end
end
