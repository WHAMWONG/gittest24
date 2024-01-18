# frozen_string_literal: true

class TodoService < BaseService
  def self.check_for_conflicting_todos(user_id, title, due_date)
    conflicting_todo = Todo.where(user_id: user_id, title: title, due_date: due_date).exists?

    if conflicting_todo
      {
        success: false,
        error_message: I18n.t('activerecord.errors.messages.taken', attribute: 'Todo', value: title)
      }
    else
      {
        success: true
      }
    end
  end
end


