# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserTokenController, type: :controller do
  it { is_expected.to be_a Knock::AuthTokenController }
end
