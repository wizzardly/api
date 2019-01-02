# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchmakingController, type: :controller do
  let(:redis) { Redis.new }

  it { is_expected.to be_a ApplicationController }
  it { is_expected.to use_before_action :authenticate_user }

  shared_context "with user in matchmaking" do
    before { redis.sadd(ApplicationConstants::MATCHMAKING_SET_KEY, user.id) }
  end

  shared_examples_for "responds with matchmaking status having in_matchmaking:" do |in_matchmaking|
    let(:expected_data) do
      { in_matchmaking: in_matchmaking }
    end

    it "responds with data" do
      expect(controller).to respond_with :success
      expect(response.body).to eq expected_data.to_json
    end
  end

  describe "#status" do
    include_context "with authenticated user"

    subject(:get_status) { get :status }

    context "when in matchmaking" do
      include_context "with user in matchmaking"

      it_behaves_like "responds with matchmaking status having in_matchmaking:", true do
        before { get_status }
      end
    end

    context "when not in matchmaking" do
      it_behaves_like "responds with matchmaking status having in_matchmaking:", false do
        before { get_status }
      end
    end
  end

  describe "#enter" do
    include_context "with authenticated user"

    subject(:post_enter) { post :enter }

    context "with unfinished match" do
      let(:expected_data) { {} }

      before do
        user.matches.create!
        post_enter
      end

      it_behaves_like "an error response", :forbidden, "pundit.user_forbidden"
    end

    context "when in matchmaking" do
      include_context "with user in matchmaking"

      it_behaves_like "responds with matchmaking status having in_matchmaking:", true do
        before { post_enter }
      end
    end

    context "when not in matchmaking" do
      it_behaves_like "responds with matchmaking status having in_matchmaking:", true do
        before { post_enter }
      end

      it "adds user to matchmaking" do
        expect { post_enter }.
          to change { redis.smembers(ApplicationConstants::MATCHMAKING_SET_KEY) }.
          from([]).
          to([ user.id.to_s ])
      end
    end
  end
end
