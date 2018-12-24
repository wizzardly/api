# frozen_string_literal: true
# == Schema Information
#
# Table name: matches
#
#  created_at :datetime         not null
#  id         :bigint(8)        not null, primary key
#  status     :integer          default(0)
#  updated_at :datetime         not null
#

require "rails_helper"

RSpec.describe Match, type: :model do
  it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to define_enum_for(:status).with(%i[active paused finished]) }

  describe ".users" do
    subject(:associate_user) { match.users << user }

    let(:match) { create :match }
    let(:user) { create :user }

    shared_examples_for "the user is not added" do
      it "does not add the user" do
        expect { associate_user }.not_to change { match.users.count }
        expect(match.users).not_to include user
      end
    end

    shared_examples_for "the user is added" do
      it "adds the user" do
        expect { associate_user }.to change { match.users.first }.from(nil).to(user)
      end
    end

    context "with fewer than max number of users" do
      context "without any user matches" do
        it_behaves_like "the user is added"
      end

      context "with only finished user matches" do
        let(:finished_match) { create :match, status: :finished }

        before { finished_match.users << user }

        it_behaves_like "the user is added"
      end

      context "with unfinished user matches" do
        let(:unfinished_match) { create :match }

        before { unfinished_match.users << user }

        it_behaves_like "the user is not added"
      end
    end

    context "when there are already the max number of users" do
      before { create_list(:user, described_class::MAX_USERS_PER_MATCH).each { |user| match.users << user } }

      it_behaves_like "the user is not added"
    end
  end
end
