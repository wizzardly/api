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

require "rails_helper"

RSpec.describe Match, type: :model do
  it { is_expected.to have_and_belong_to_many(:users) }
  it { is_expected.to define_enum_for(:status).with(%i[pending active paused finished]) }

  context "when pending" do
    subject { build :match }

    it { is_expected.to validate_absence_of(:started_at) }
    it { is_expected.to validate_absence_of(:paused_at) }
    it { is_expected.to validate_absence_of(:finished_at) }
  end

  context "when active" do
    subject { build :match, :active }

    it { is_expected.to validate_presence_of(:started_at) }
    it { is_expected.to validate_absence_of(:paused_at) }
    it { is_expected.to validate_absence_of(:finished_at) }
  end

  context "when paused" do
    subject { build :match, :paused }

    it { is_expected.to validate_presence_of(:started_at) }
    it { is_expected.to validate_presence_of(:paused_at) }
    it { is_expected.to validate_absence_of(:finished_at) }
  end

  context "when finished" do
    subject { build :match, :finished }

    it { is_expected.to validate_presence_of(:started_at) }
    it { is_expected.to validate_absence_of(:paused_at) }
    it { is_expected.to validate_presence_of(:finished_at) }
  end

  describe "#status" do
    context "when pending" do
      subject { build :match }

      it { is_expected.to be_can_activate }
      it { is_expected.not_to be_can_pause }
      it { is_expected.not_to be_can_unpause }
      it { is_expected.to be_can_finish }
    end

    context "when active" do
      subject { build :match, :active }

      it { is_expected.not_to be_can_activate }
      it { is_expected.to be_can_pause }
      it { is_expected.not_to be_can_unpause }
      it { is_expected.to be_can_finish }
    end

    context "when paused" do
      subject { build :match, :paused }

      it { is_expected.not_to be_can_activate }
      it { is_expected.not_to be_can_pause }
      it { is_expected.to be_can_unpause }
      it { is_expected.to be_can_finish }
    end

    context "when finished" do
      subject { build :match, :finished }

      it { is_expected.not_to be_can_activate }
      it { is_expected.not_to be_can_pause }
      it { is_expected.not_to be_can_unpause }
      it { is_expected.not_to be_can_finish }
    end
  end

  describe "#users" do
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

    shared_examples_for "the user is added when the match is pending" do
      context "when pending" do
        let(:match) { create :match }

        it_behaves_like "the user is added"
      end

      context "when active" do
        let(:match) { create :match, :active }

        it_behaves_like "the user is not added"
      end

      context "when paused" do
        let(:match) { create :match, :paused }

        it_behaves_like "the user is not added"
      end

      context "when finished" do
        let(:match) { create :match, :finished }

        it_behaves_like "the user is not added"
      end
    end

    context "with fewer than required number of users" do
      context "without any user matches" do
        it_behaves_like "the user is added when the match is pending"
      end

      context "with only finished user matches" do
        let(:finished_match) { create :match, :finished }

        before { finished_match.users << user }

        it_behaves_like "the user is added when the match is pending"
      end

      context "with unfinished user matches" do
        let(:unfinished_match) { create :match }

        before { unfinished_match.users << user }

        it_behaves_like "the user is not added"
      end
    end

    context "when there are already the required number of users" do
      before { create_list(:user, described_class::REQUIRED_USERS_PER_MATCH).each { |user| match.users << user } }

      it_behaves_like "the user is not added"
    end
  end

  shared_context "with an active match" do
    let(:match) { build :match, :active }

    before { Timecop.freeze }
  end

  describe "#activate!" do
    subject(:activate!) { match.activate! }

    let(:match) { create :match }

    before { Timecop.freeze }

    context "without the required number of users" do
      it "raises" do
        expect { activate! }.to raise_error RuntimeError, "Invalid transition"
      end
    end

    context "with the required number of users" do
      before { create_list(:user, described_class::REQUIRED_USERS_PER_MATCH).each { |user| match.users << user } }

      it "sets started_at" do
        expect { activate! }.to change { match.started_at }.from(nil).to(Time.current)
      end
    end
  end

  describe "#pause!" do
    include_context "with an active match"

    subject(:pause!) { match.pause! }

    it "sets paused_at" do
      expect { pause! }.to change { match.paused_at }.from(nil).to(Time.current)
    end
  end

  describe "#unpause!" do
    subject(:unpause!) { match.unpause! }

    let(:match) { build :match, :paused, paused_at: Time.current }

    before { Timecop.freeze }

    it "clears paused_at" do
      expect { unpause! }.to change { match.paused_at }.from(Time.current).to(nil)
    end
  end

  describe "#finish!" do
    include_context "with an active match"

    subject(:finish!) { match.finish! }

    it "sets finished_at" do
      expect { finish! }.to change { match.finished_at }.from(nil).to(Time.current)
    end
  end
end
