# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationSerializer, type: :serializer do
  it { expect(described_class <= ActiveModel::Serializer).to be }
end
