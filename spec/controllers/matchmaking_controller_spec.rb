# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchmakingController, type: :controller do
  it { is_expected.to be_a ApplicationController }
  it { is_expected.to use_before_action :authenticate_user }

  describe "#status" do
    include_context "with authenticated user"

    shared_examples_for "in_matchmaking:" do |in_matchmaking|
      before { get :status }

      let(:expected_data) do
        { in_matchmaking: in_matchmaking }
      end

      it "responds with data" do
        expect(controller).to respond_with :success
        expect(response.body).to eq expected_data.to_json
      end
    end

    context "when in matchmaking" do
      before { Redis.new.sadd(ApplicationConstants::MATCHMAKING_SET_KEY, user.id) }

      it_behaves_like "in_matchmaking:", true
    end

    context "when not in matchmaking" do
      it_behaves_like "in_matchmaking:", false
    end
  end
end
