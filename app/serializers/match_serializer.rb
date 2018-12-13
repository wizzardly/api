# frozen_string_literal: true

# == Schema Information
#
# Table name: matches
#
#  created_at :datetime         not null
#  finished   :boolean          default(FALSE)
#  id         :bigint(8)        not null, primary key
#  updated_at :datetime         not null
#

class MatchSerializer < ApplicationSerializer
  attributes :id, :finished
end
