# frozen_string_literal: true

require "rails_helper"

RSpec.describe <%= class_name %>Cache, type: :cache do
  it { expect(described_class <= ApplicationCache).to be_truthy }
end
