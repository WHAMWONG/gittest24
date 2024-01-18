# typed: true
# frozen_string_literal: true

class FolderPolicy < ApplicationPolicy
  def create?
    # Assuming that any logged-in user can create a folder
    # This can be expanded with more complex logic if needed
    !user.nil?
  end
end

