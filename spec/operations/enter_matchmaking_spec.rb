# frozen_string_literal: true

require "rails_helper"

RSpec.describe EnterMatchmaking, type: :operation do
  subject(:execute) { operation.execute }

  let(:operation) { described_class.new(state) }
  let(:state) { EnterMatchmakingState.new(user: user) }
  let(:user) { create :user }
  let(:redis) { state.redis }
  let(:expected_set) { [ user.id.to_s ] }

  it "enters the user into matchmaking" do
    expect { execute }.to change { redis.smembers(ApplicationConstants::MATCHMAKING_SET_KEY) }.from([]).to(expected_set)
  end
end
