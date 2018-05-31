# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserInfoController, type: :controller do
  it { is_expected.to be_a ApplicationController }
  it { is_expected.to use_before_action :authenticate_user }

  before { allow(controller).to receive(:authorize).and_call_original }

  describe "GET #show" do
    let(:headers) { nil }

    context "when guest" do
      before { get :show }

      it { is_expected.to respond_with :unauthorized }
    end

    context "when user" do
      include_context "with authenticated user"

      before { get :show }

      it_behaves_like "a serialized model" do
        let(:model) { user }
      end
    end
  end
end
