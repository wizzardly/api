# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  it { expect(described_class._layout).to eq "mailer" }
end
