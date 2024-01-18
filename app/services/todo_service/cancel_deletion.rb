class TodoService::CancelDeletion < BaseService
  attr_reader :user, :todo_id

  def initialize(user, todo_id)
    @user = user
    @todo_id = todo_id
  end

  def call
    todo = Todo.find_by(id: todo_id, deleted_at: nil)
    return error_response('Todo not found or already deleted') unless todo

    policy = TodoPolicy.new(user, todo)
    return error_response('Not authorized to cancel deletion') unless policy.cancel_deletion?

    # Log the cancellation action for auditing purposes
    # Assuming there is a method `log_cancellation` for logging (not shown here)
    log_cancellation(user.id, todo_id)

    success_response('Deletion cancellation confirmed')
  rescue StandardError => e
    error_response(e.message)
  end

  private

  def log_cancellation(user_id, todo_id)
    # Implementation of logging logic
  end
end
