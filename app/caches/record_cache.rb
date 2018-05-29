# frozen_string_literal: true

class RecordCache < ApplicationCache
  class << self
    def record_class
      name.chomp("Cache").constantize
    end
  end

  protected

  delegate :record_class, to: :class

  def generate_value!
    ActiveModelSerializers::SerializableResource.new(record).to_json
  end

  def record
    record_class.find(id)
  end
end
