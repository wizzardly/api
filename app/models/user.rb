# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  created_at      :datetime         not null
#  email           :string           not null
#  first_name      :string           not null
#  id              :bigint(8)        not null, primary key
#  last_name       :string           not null
#  password_digest :string           not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  has_secure_password

  validates :first_name, length: { minimum: 2 }, presence: true
  validates :last_name, length: { minimum: 2 }, presence: true
  validates :email, format: %r{\A[^@\s]+@[^@\s]+\z}, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6, maximum: 20 }, if: -> { password.present? }

  strip_attributes except: :password_digest, collapse_spaces: true

  before_save :downcase_email

  def initials
    "#{first_name.chr}#{last_name.chr}"
  end

  def name
    "#{first_name} #{last_name}"
  end

  private

  def downcase_email
    self.email = email.downcase if email?
  end
end
