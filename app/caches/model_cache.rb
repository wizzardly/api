# frozen_string_literal: true

class ModelCache < ApplicationCache
  class << self
    def model_class
      name.chomp("Cache").constantize
    end
  end

  protected

  delegate :model_class, to: :class

  def generate_value!
    ActiveModelSerializers::SerializableResource.new(model).to_json
  end

  def model
    model_class.find(id)
  end
end
