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

class Match < ApplicationRecord
  REQUIRED_USERS_PER_MATCH = 2

  has_and_belongs_to_many :users, -> { distinct }, before_add: :validate_users

  validates :started_at, absence: true, if: :pending?
  validates :started_at, presence: true, unless: :pending?

  validates :paused_at, absence: true, unless: :paused?
  validates :paused_at, presence: true, if: :paused?

  validates :finished_at, absence: true, unless: :finished?
  validates :finished_at, presence: true, if: :finished?

  scope :unfinished, -> { where(status: unfinished_statuses) }

  enum status: %i[pending active paused finished] do
    event :activate do
      before { self.started_at = Time.current }

      transition pending: :active, if: -> { required_users? }
    end

    event :pause do
      before { self.paused_at = Time.current }

      transition active: :paused
    end

    event :unpause do
      before { self.paused_at = nil }

      transition paused: :active
    end

    event :finish do
      before { self.finished_at = Time.current }

      transition all - %i[finished] => :finished
    end
  end

  class << self
    def unfinished_statuses
      statuses.except(:finished).keys
    end
  end

  def required_users?
    users.count == REQUIRED_USERS_PER_MATCH
  end

  private

  def validate_users(user)
    raise ActiveRecord::Rollback if !pending? || users.count >= REQUIRED_USERS_PER_MATCH || user.matches.unfinished.any?
  end
end
