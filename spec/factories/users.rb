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
#  matches_count   :integer          default(0)
#  password_digest :string           not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password "mygreatpassword"
  end
end
