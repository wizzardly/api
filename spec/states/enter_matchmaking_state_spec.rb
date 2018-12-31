# frozen_string_literal: true

require "rails_helper"

RSpec.describe EnterMatchmakingState, type: :state do
  subject { described_class }

  it { is_expected.to inherit_from ApplicationState }
  it { is_expected.to have_argument :user }
end
