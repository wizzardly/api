# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationPolicy::Scope, type: :policy_scope do
  subject(:policy) { described_class.new(user, scope) }

  let(:user) { double }
  let(:scope) { double }

  describe ".new" do
    it "initializes with a user and the record" do
      expect(policy.user).to eq user
      expect(policy.scope).to eq scope
    end
  end

  describe "#resolve" do
    it "returns the scope" do
      expect(policy.resolve).to eq scope
    end
  end
end
