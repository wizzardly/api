RSpec.shared_examples_for "a serialized model" do
  it "responds with data" do
    expect(controller).to respond_with :success
    expect(response.body).to eq ActiveModelSerializers::SerializableResource.new(model).to_json
  end
end
