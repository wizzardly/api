# frozen_string_literal: true

# RSpec matcher to test operations in flows.
#
# Usage:
#
# RSpec.describe FooFlow, type: :flow do
#   subject { described_class }
#
#   it { is_expected.to have_operations Foo }
# end

RSpec::Matchers.define :have_operations do |operations|
  match do
    expect(subject_class._operations).to eq Array.wrap(operations)
  end

  description do
    "have operations #{operations}"
  end

  failure_message do |example|
    "expected #{example} to have operations #{operations}"
  end

  failure_message_when_negated do |example|
    "expected #{example} not to have operations #{operations}"
  end

  def subject_class
    subject.is_a?(Class) ? subject : subject.class
  end
end
