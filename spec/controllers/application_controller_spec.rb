# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  it { is_expected.to be_a ActionController::API }
end
