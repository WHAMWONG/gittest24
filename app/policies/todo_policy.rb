class TodoPolicy < ApplicationPolicy
  def attach?
    record.user_id == user.id
  end

  def cancel_deletion?
    record.user_id == user.id
  end

  def destroy?
    record.user_id == user.id
  end
end

