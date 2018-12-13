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

require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to be_a_kind_of ApplicationRecord }

  subject(:described_model) { build :user }

  describe "Indices" do
    it { is_expected.to have_db_index(:email).unique }
  end

  shared_examples "name field" do |field|
    it { is_expected.to validate_presence_of(field) }
    it { is_expected.to strip_attribute(field).collapse_spaces }
    it { is_expected.to validate_length_of(field).is_at_least(2) }
  end

  describe "#first_name" do
    it_behaves_like "name field", :first_name
  end

  describe "#last_name" do
    it_behaves_like "name field", :last_name
  end

  describe "#password" do
    subject(:described_model) { build :user, password: nil }

    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password).is_at_least(6).is_at_most(20) }

    it "digests the password" do
      expect { described_model.update!(password: SecureRandom.hex(8)) }.
        to change { described_model.password_digest }.
        from nil
    end
  end

  describe "#email" do
    let(:upcased_email) { Faker::Internet.email.upcase }

    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value("a@b.c").for(:email) }
    it { is_expected.to allow_value("more.complex+ema.il-thing@still.ok.gov").for(:email) }
    it { is_expected.not_to allow_value("email with space@not.ok").for(:email) }
    it { is_expected.not_to allow_value("@twitter.fails").for(:email) }
    it { is_expected.not_to allow_value("gmail.com").for(:email) }
    it { is_expected.to strip_attribute(:email).collapse_spaces }

    it "downcases the email" do
      expect { described_model.update(email: upcased_email) }.
        to change { described_model.email }.
        to upcased_email.downcase
    end
  end

  describe "#password_digest" do
    it { is_expected.not_to strip_attribute(:password_digest) }
  end

  describe "#name" do
    let(:user) { create :user }
    let(:first_name) { user.first_name }
    let(:last_name) { user.last_name }

    subject { user.name }

    it { is_expected.to eq "#{first_name} #{last_name}" }
  end

  describe "#initials" do
    let(:user) { create :user }
    let(:first_name) { user.first_name }
    let(:last_name) { user.last_name }

    subject { user.initials }

    it { is_expected.to eq "#{first_name.chr}#{last_name.chr}" }
  end
end
