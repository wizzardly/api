# frozen_string_literal: true

require "rails_helper"

RSpec.describe <%= class_name %>CacheLogger, type: :logger do
  it { expect(described_class <= ApplicationCacheLogger).to be_truthy }
end
