# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationState, type: :state do
  subject { described_class }

  it { is_expected.to inherit_from StateBase }
end
