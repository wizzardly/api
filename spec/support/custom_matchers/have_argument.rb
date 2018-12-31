# frozen_string_literal: true

# RSpec matcher to test arguments in states.
#
# Usage:
#
# RSpec.describe FooState, type: :state do
#   subject { described_class }
#
#   it { is_expected.to have_argument :foo }
# end

RSpec::Matchers.define :have_argument do |argument|
  match do
    expect(subject_class._arguments).to include argument
  end

  description do
    "have argument #{argument}"
  end

  failure_message do |example|
    "expected #{example} to have argument #{argument}"
  end

  failure_message_when_negated do |example|
    "expected #{example} not to have argument #{argument}"
  end

  def subject_class
    subject.is_a?(Class) ? subject : subject.class
  end
end
