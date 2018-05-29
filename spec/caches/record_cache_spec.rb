# frozen_string_literal: true

require "rails_helper"

RSpec.describe RecordCache, type: :cache do
  it { expect(described_class <= ApplicationCache).to be_truthy }

  shared_context "with example record" do
    let(:record_name) { Faker::Internet.domain_word.capitalize }
    let(:class_name) { "#{record_name}Cache" }
    let(:example_class) { Class.new(RecordCache) }
    let(:example_record) { Class.new(ApplicationRecord) }

    before do
      stub_const(class_name, example_class)
      stub_const(record_name, example_record)
    end
  end

  describe ".record_class" do
    include_context "with example record"

    subject { example_class.record_class }

    it { is_expected.to eq example_record }
  end

  describe "#record_class" do
    let(:example_record) { Class.new }
    let(:example_class) do
      Class.new(RecordCache) do
        protected

        def record_class
          "override"
        end
      end
    end

    subject { example_class.new(0).__send__(:record_class) }

    it { is_expected.to eq "override" }
  end

  describe "#generate_value!" do
    include_context "with example record"

    let(:id) { rand(1..100) }
    let(:serializer) { instance_double(ApplicationSerializer) }
    let(:record) { instance_double(example_record) }
    let(:record_json) { Hash[*Faker::Lorem.words(4)] }

    before do
      allow(example_record).to receive(:find).with(id).and_return(record)
      allow(ActiveModelSerializers::SerializableResource).to receive(:new).with(record).and_return(serializer)
      allow(serializer).to receive(:to_json).and_return(record_json)
    end

    subject { example_class.new(id).__send__(:generate_value!) }

    it { is_expected.to eq record_json }
  end

  describe "#record" do
    include_context "with example record"

    let(:id) { rand(1..100) }
    let(:record) { instance_double(example_record) }

    before { allow(example_record).to receive(:find).with(id).and_return(record) }

    subject { example_class.new(id).__send__(:record) }

    it { is_expected.to eq record }
  end
end
