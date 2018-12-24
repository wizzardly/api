# == Schema Information
#
# Table name: matches
#
#  created_at :datetime         not null
#  id         :bigint(8)        not null, primary key
#  status     :integer          default(0)
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :match do
    status :active
  end
end
