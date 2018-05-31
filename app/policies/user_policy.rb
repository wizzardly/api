# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def show?
    return false if user.nil?

    user.id == record.id
  end

  class Scope < Scope; end
end
