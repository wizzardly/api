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

class Match < ApplicationRecord
  MAX_USERS_PER_MATCH = 2

  has_and_belongs_to_many :users, -> { distinct }, before_add: :validate_users

  def validate_users(user)
    raise ActiveRecord::Rollback if users.count >= MAX_USERS_PER_MATCH || user.matches.exists?(finished: false)
  end
end
