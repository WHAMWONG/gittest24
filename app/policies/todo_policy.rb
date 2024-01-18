class TodoPolicy < ApplicationPolicy
  def attach?
    record.user_id == user.id
  end

  def destroy?
    record.user_id == user.id
  end
end
end

# In TodosController, use this policy to authorize the action
# before attaching the file.
# Example:
# authorize @todo, :attach?
# This assumes that @todo is the instance of Todo you want to attach files to.
