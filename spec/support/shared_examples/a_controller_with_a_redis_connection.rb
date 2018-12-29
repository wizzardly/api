# frozen_string_literal: true

RSpec.shared_examples_for "a controller with a redis connection" do
  controller do
    skip_after_action :verify_authorized

    def index
      redis
      redis
      redis
    end
  end

  let(:redis) { instance_double Redis }

  before do
    allow(Redis).to receive(:new).and_return(redis)
    get :index
  end

  it "memoizes a redis connection" do
    expect(Redis).to have_received(:new).once
  end
end
