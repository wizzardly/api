# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationFlow, type: :flow do
  subject { described_class }

  it { is_expected.to inherit_from FlowBase }
end
