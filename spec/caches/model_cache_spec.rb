# frozen_string_literal: true

require "rails_helper"

RSpec.describe ModelCache, type: :cache do
  it { expect(described_class <= ApplicationCache).to be_truthy }

  shared_context "with example model" do
    let(:model_name) { Faker::Internet.domain_word.capitalize }
    let(:class_name) { "#{model_name}Cache" }
    let(:example_class) { Class.new(ModelCache) }
    let(:example_model) { Class.new(ApplicationRecord) }

    before do
      stub_const(class_name, example_class)
      stub_const(model_name, example_model)
    end
  end

  describe ".model_class" do
    include_context "with example model"

    subject { example_class.model_class }

    it { is_expected.to eq example_model }
  end

  describe "#model_class" do
    let(:example_model) { Class.new }
    let(:example_class) do
      Class.new(ModelCache) do
        protected

        def model_class
          "override"
        end
      end
    end

    subject { example_class.new(0).__send__(:model_class) }

    it { is_expected.to eq "override" }
  end

  describe "#generate_value!" do
    include_context "with example model"

    let(:id) { rand(1..100) }
    let(:serializer) { instance_double(ApplicationSerializer) }
    let(:model) { instance_double(example_model) }
    let(:model_json) { Hash[*Faker::Lorem.words(4)] }

    before do
      allow(example_model).to receive(:find).with(id).and_return(model)
      allow(ActiveModelSerializers::SerializableResource).to receive(:new).with(model).and_return(serializer)
      allow(serializer).to receive(:to_json).and_return(model_json)
    end

    subject { example_class.new(id).__send__(:generate_value!) }

    it { is_expected.to eq model_json }
  end

  describe "#model" do
    include_context "with example model"

    let(:id) { rand(1..100) }
    let(:model) { instance_double(example_model) }

    before { allow(example_model).to receive(:find).with(id).and_return(model) }

    subject { example_class.new(id).__send__(:model) }

    it { is_expected.to eq model }
  end
end
