class TodosController < ApplicationController
  # ... other controller actions ...

  def create_attachment
    @attachment = Attachment.new(attachment_params)
    if @attachment.save
      render json: Jbuilder.encode { |json|
        json.status 201
        json.attachment do
          json.id @attachment.id
          json.todo_id @attachment.todo_id
          json.file_path @attachment.file_path
          json.file_name @attachment.file_name
        end
        json.todo do
          json.id @attachment.todo.id
          json.user_id @attachment.todo.user_id
          json.title @attachment.todo.title
          json.description @attachment.todo.description
          json.due_date @attachment.todo.due_date.iso8601
          json.category @attachment.todo.category
          json.priority @attachment.todo.priority
          json.is_recurring @attachment.todo.is_recurring
          json.recurrence @attachment.todo.recurrence
        end
      }, status: :created
    else
      render json: { errors: @attachment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def attachment_params
    # Assuming params[:attachment] is the key that contains all the attachment attributes
    params.require(:attachment).permit(:todo_id, :file_path, :file_name)
  end

  # ... other private methods ...
end
