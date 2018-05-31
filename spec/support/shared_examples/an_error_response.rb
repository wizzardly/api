# frozen_string_literal: true

RSpec.shared_examples_for "an error response" do |expected_status, expected_message_key|
  let(:parsed_body) { JSON.parse(response.body) }

  it "responds with an error" do
    expect(controller).to respond_with expected_status
    expect(parsed_body["message"]).to eq t(expected_message_key)
  end
end
