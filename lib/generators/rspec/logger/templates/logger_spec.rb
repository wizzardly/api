# frozen_string_literal: true

require "rails_helper"

RSpec.describe <%= class_name %>Logger, type: :logger do
  it { expect(described_class <= ApplicationLogger).to be_truthy }
end
