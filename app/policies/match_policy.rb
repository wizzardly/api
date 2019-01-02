# frozen_string_literal: true

class MatchPolicy < ApplicationPolicy
  def create?
    return false if user.nil?

    user.matches.unfinished.none?
  end

  class Scope < Scope; end
end
