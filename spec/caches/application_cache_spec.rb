# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationCache, type: :cache do
  let(:redis) { Redis.new }
  let(:id) { rand(1..100) }
  let(:cache_key) { described_class.cache_key }

  describe ".flush_entire_cache" do
    subject(:example_method) { described_class.flush_entire_cache }

    let(:other_id) { id + 1 }
    let(:base_key) { ApplicationCache::BASE_CACHE_KEY }
    let(:unrelated_key) { Faker::Lorem.word }
    let(:cache_1_key) { "#{base_key}:Something" }
    let(:cache_2_key) { "#{base_key}:SomethingElse" }
    let(:starting_keys) do
      [ unrelated_key, base_key, cache_1_key, cache_2_key ]
    end

    before do
      redis.set(unrelated_key, "test")
      redis.set(base_key, "test")
      redis.hset(cache_1_key, id, "test")
      redis.hset(cache_2_key, id, "test")
      redis.hset(cache_1_key, other_id, "test")
      redis.hset(cache_2_key, other_id, "test")
    end

    it "clears all the cache keys in the namespace but leaves unrelated keys alone" do
      expect { example_method }.to change { redis.keys }.from(array_including(starting_keys)).to [ unrelated_key ]
    end

    it_behaves_like "an instrumented event", "flush_entire_cache.application_cache" do
      before { example_method }

      let(:expected_data) do
        { keyspace: base_key }
      end
    end
  end

  describe ".clear_all" do
    subject(:example_method) { described_class.clear_all }

    let(:other_id) { id + 1 }
    let(:unrelated_key) { Faker::Lorem.word }
    let(:starting_keys) do
      [ cache_key, unrelated_key ]
    end

    before do
      redis.hset(cache_key, id, "test")
      redis.hset(cache_key, other_id, "test")
      redis.hset(unrelated_key, id, "test")
      redis.hset(unrelated_key, other_id, "test")
    end

    it "clears all values from all site caches" do
      expect { example_method }.to change { redis.keys }.from(array_including(starting_keys)).to([ unrelated_key ])
    end

    it_behaves_like "an instrumented event", "clear_all.application_cache" do
      before { example_method }

      let(:expected_data) do
        { keyspace: cache_key }
      end
    end
  end

  describe ".get" do
    subject(:example_method) { described_class.get(id) }

    let(:instance) { instance_double(described_class) }
    let(:value) { Faker::Lorem.word }

    before do
      allow(described_class).to receive(:new).with(id).and_return(instance)
      allow(instance).to receive(:get).and_return(value)
    end

    it { is_expected.to eq value }
  end

  describe ".clear" do
    subject(:example_method) { described_class.clear(id) }

    let(:instance) { instance_double(described_class) }
    let(:value) { rand }

    before do
      allow(described_class).to receive(:new).with(id).and_return(instance)
      allow(instance).to receive(:clear).and_return(value)
    end

    it { is_expected.to eq value }
  end

  describe ".cache_key" do
    subject { example_class.cache_key }

    let(:class_name) { Faker::Internet.domain_word.capitalize }
    let(:example_class) { Class.new(described_class) }

    before { stub_const(class_name, example_class) }

    it { is_expected.to eq "#{ApplicationCache::BASE_CACHE_KEY}:#{class_name}" }
  end

  describe "#get" do
    subject(:example_method) { instance.get }

    let(:instance) { described_class.new(id) }

    context "when no value has been cached" do
      shared_context "with expected data" do
        let(:extra_data) do
          {}
        end

        let(:expected_data) do
          { cache_key: cache_key, id: id }.merge(extra_data)
        end

        before { example_method }
      end

      shared_examples_for "a cache miss" do
        it_behaves_like "an instrumented event", "miss.application_cache" do
          include_context "with expected data"
        end
      end

      shared_examples_for "a miss which doesn't cache" do
        it "does not raise" do
          expect { example_method }.not_to raise_error
        end

        it "does not set a cache value" do
          expect { example_method }.not_to change { redis.hget(cache_key, id) }.from(nil)
        end

        it_behaves_like "a cache miss"
      end

      context "when generate_value! has not been defined" do
        it "raises" do
          expect { example_method }.to raise_error NotImplementedError
        end

        it_behaves_like "a cache miss" do
          before { allow(instance).to receive(:generate_value!) }
        end
      end

      context "when generate_value! raises an error" do
        before { allow(instance).to receive(:generate_value!).and_raise StandardError }

        it_behaves_like "a miss which doesn't cache"

        it_behaves_like "an instrumented event", "error_generating_value.application_cache" do
          include_context "with expected data" do
            let(:extra_data) do
              { generation_error: an_instance_of(StandardError) }
            end
          end
        end
      end

      context "when generate_value! raises an ApplicationCache::CacheRollback" do
        before { allow(instance).to receive(:generate_value!).and_raise ApplicationCache::CacheRollback }

        it_behaves_like "a miss which doesn't cache"

        it_behaves_like "an instrumented event", "rollback.application_cache" do
          include_context "with expected data" do
            let(:extra_data) do
              { rollback_error: an_instance_of(ApplicationCache::CacheRollback) }
            end
          end
        end
      end

      context "when generate_value! returns a value" do
        let(:generated_value) { Hash[*Faker::Lorem.unique.words(4)].to_json }

        before { allow(instance).to receive(:generate_value!).and_return(generated_value) }

        it "generates the value and caches it" do
          expect { example_method }.to change { redis.hget(cache_key, id) }.from(nil).to(generated_value)
        end

        it_behaves_like "a cache miss"

        it_behaves_like "an instrumented event", "generate_and_cache_value.application_cache" do
          include_context "with expected data"
        end
      end
    end

    context "when a value has been cached" do
      before do
        allow(instance).to receive(:generate_value!)
        redis.hset(cache_key, id, cached_value)
      end

      shared_examples_for "there's a cached value" do
        before { example_method }

        it "does not call generate_value!" do
          expect(instance).not_to have_received(:generate_value!)
        end

        it_behaves_like "an instrumented event", "hit.application_cache" do
          let(:expected_data) do
            { cache_key: cache_key, id: id }
          end
        end
      end

      context "when the cached value is nil" do
        let(:cached_value) { nil }

        it { is_expected.to be_nil }

        it_behaves_like "there's a cached value"
      end

      context "when the cached value is json" do
        let(:random_hash) do
          { Faker::Lorem.word => rand(1..10) }
        end

        let(:cached_value) { random_hash.to_json }

        it { is_expected.to eq random_hash }

        it_behaves_like "there's a cached value"
      end

      context "when the cached value is a text string" do
        let(:cached_value) { Faker::Lorem.sentence }

        it { is_expected.to eq cached_value }

        it_behaves_like "there's a cached value"
      end
    end
  end

  describe "#clear" do
    subject(:example_method) { instance.clear }

    let(:instance) { described_class.new(id) }
    let(:other_id) { id + 1 }
    let(:starting_values) do
      { id.to_s => "test", other_id.to_s => "test" }
    end
    let(:expected_values) do
      { other_id.to_s => "test" }
    end

    before do
      redis.hset(cache_key, id, "test")
      redis.hset(cache_key, other_id, "test")
    end

    it "removes only the specific id from the cache key" do
      expect { example_method }.to change { redis.hgetall(cache_key) }.from(starting_values).to(expected_values)
    end

    it_behaves_like "an instrumented event", "clear.application_cache" do
      before { example_method }

      let(:expected_data) do
        { cache_key: cache_key, id: id }
      end
    end
  end

  describe "#cache_key" do
    subject { described_class.new(id) }

    it { is_expected.to delegate_method(:cache_key).to(:class) }
  end
end
