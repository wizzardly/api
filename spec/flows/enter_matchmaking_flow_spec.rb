# frozen_string_literal: true

require "rails_helper"

RSpec.describe EnterMatchmakingFlow, type: :flow do
  subject { described_class }

  it { is_expected.to inherit_from ApplicationFlow }
  it { is_expected.to have_operations EnterMatchmaking }
end
