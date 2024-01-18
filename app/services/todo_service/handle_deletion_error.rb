# typed: true
class TodoService::HandleDeletionError < BaseService
  def call(id)
    todo = Todo.find_by(id: id)
    if todo
      user_id = todo.user_id
      logger.error "Deletion error for Todo with ID: #{id}, User ID: #{user_id}"
      {
        success: false,
        error_message: I18n.t('activerecord.errors.messages.try_again_later'),
        user_id: user_id
      }
    else
      { success: false, error_message: I18n.t('activerecord.errors.messages.record_not_found'), user_id: nil }
    end
  end
end
