# frozen_string_literal: true

require "rails_helper"

RSpec.describe MatchCache, type: :cache do
  it { expect(described_class <= ModelCache).to be_truthy }
end
