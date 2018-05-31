# frozen_string_literal: true

RSpec.shared_context "with authenticated user" do
  let(:user) { create :user }
  let(:token) { Knock::AuthToken.new(payload: { sub: user.id }).token }
  let(:authentication_headers) do
    { "Authorization": "Bearer #{token}" }
  end

  before { request.headers.merge! authentication_headers }
end
