module TodoService
  class Delete < BaseService
    def initialize(user_id, todo_id)
      @user_id = user_id
      @todo_id = todo_id
    end

    def execute
      user = User.find(@user_id)
      todo = user.todos.find_by(id: @todo_id)

      raise ActiveRecord::RecordNotFound, 'To-Do item not found' unless todo

      # Assuming TodoPolicy and Pundit are set up for authorization
      raise Pundit::NotAuthorizedError, 'Not authorized to delete this To-Do item' unless TodoPolicy.new(user, todo).destroy?

      todo.update!(deleted_at: Time.current)

      # Assuming there is a logging mechanism in place
      log_deletion_action(user.id, todo.id)

      'To-Do item successfully deleted'
    end

    private

    def log_deletion_action(user_id, todo_id)
      # Log deletion action here
    end
  end
end
