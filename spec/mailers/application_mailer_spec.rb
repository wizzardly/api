# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationMailer, type: :mailer do
  it { is_expected.to be_a_kind_of(Roadie::Rails::Automatic) }
  it { expect(described_class._layout).to eq "mailer" }
end
