# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationCacheLogger, type: :logger do
  include_context "with application logger"

  shared_examples_for "a keyspace logger" do |entry|
    let(:keyspace) { Faker::Lorem.sentence }
    let(:payload) do
      { keyspace: keyspace }
    end

    let(:expected_arguments) do
      { entry: entry, keyspace: keyspace }
    end

    it "info logs with the expected parameters" do
      allow(Rails.logger).to receive(:info) do |&block|
        expect(block.yield).to eq expected_arguments
      end

      instance.public_send(entry, event)
    end
  end

  shared_examples_for "a cache info logger" do |entry|
    let(:id) { rand(1..100) }
    let(:cache_key) { Faker::Lorem.word }
    let(:payload) do
      { id: id, cache_key: cache_key }
    end

    let(:expected_arguments) do
      { entry: entry, id: id, cache_key: cache_key }
    end

    it "info logs with the expected parameters" do
      allow(Rails.logger).to receive(:info) do |&block|
        expect(block.yield).to eq expected_arguments
      end

      instance.public_send(entry, event)
    end
  end

  shared_examples_for "a cache error logger" do |entry, error_key, error_class|
    let(:id) { rand(1..100) }
    let(:cache_key) { Faker::Lorem.word }
    let(:loggable_error) { Hash[*Faker::Lorem.unique.words(4)] }
    let(:error) { instance_double(error_class) }
    let(:payload) do
      { id: id, cache_key: cache_key }.merge(error_key => error)
    end

    let(:expected_arguments) do
      { entry: entry, id: id, cache_key: cache_key }.merge(loggable_error)
    end

    before { allow(instance).to receive(:loggable_error).and_return(loggable_error) }

    it "info logs with the expected parameters" do
      allow(Rails.logger).to receive(:error) do |&block|
        expect(block.yield).to eq expected_arguments
      end

      instance.public_send(entry, event)
    end
  end

  it { expect(described_class <= ApplicationLogger).to be_truthy }

  describe "#flush_entire_cache" do
    it_behaves_like "a keyspace logger", :flush_entire_cache
  end

  describe "#clear_all" do
    it_behaves_like "a keyspace logger", :clear_all
  end

  describe "#clear" do
    it_behaves_like "a cache info logger", :clear
  end

  describe "#hit" do
    it_behaves_like "a cache info logger", :hit
  end

  describe "#miss" do
    it_behaves_like "a cache info logger", :miss
  end

  describe "#generate_and_cache_value" do
    it_behaves_like "a cache info logger", :generate_and_cache_value
  end

  describe "#error_generating_value" do
    it_behaves_like "a cache error logger", :error_generating_value, :generation_error, StandardError
  end

  describe "#rollback" do
    it_behaves_like "a cache error logger", :rollback, :rollback_error, ApplicationCache::CacheRollback
  end
end
