class TodoService::AttachFile < BaseService
  attr_reader :todo_id, :file_path, :file_name

  def initialize(todo_id:, file_path:, file_name:)
    @todo_id = todo_id
    @file_path = file_path
    @file_name = file_name
  end

  def call
    validate_todo
    validate_file_details

    attachment = Attachment.create!(
      todo_id: todo_id,
      file_path: file_path,
      file_name: file_name
    )

    { id: attachment.id, message: 'Attachment was successfully stored.' }
  rescue => e
    { error: e.message }
  end

  private

  def validate_todo
    raise 'Todo item not found' unless Todo.exists?(todo_id)
  end

  def validate_file_details
    raise 'File details are invalid' if file_path.blank? || file_name.blank?
  end
end
