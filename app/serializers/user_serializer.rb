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

class UserSerializer < ApplicationSerializer
  attributes :name, :first_name, :last_name, :initials, :email
end
