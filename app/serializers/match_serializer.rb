# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  created_at  :datetime         not null
#  finished_at :datetime
#  id          :bigint(8)        not null, primary key
#  paused_at   :datetime
#  started_at  :datetime
#  status      :integer          default("pending")
#  updated_at  :datetime         not null
#

class MatchSerializer < ApplicationSerializer
  attributes :id, :status, :started_at, :paused_at, :finished_at
end
