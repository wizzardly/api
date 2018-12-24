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

FactoryBot.define do
  factory :match do
    status :pending

    trait :active do
      status :active
      started_at { rand(0..10).minutes.ago }
    end

    trait :paused do
      active
      status :paused
      paused_at { rand(0..60).seconds.ago }
    end

    trait :finished do
      active
      status :finished
      finished_at { rand(0..7).days.ago }
    end
  end
end
