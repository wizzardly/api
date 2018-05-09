# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationRecord, type: :model do
  it "extends the base class" do
    expect(described_class <= ActiveRecord::Base).to be_truthy
  end
end
