
module Api
  class TodosController < Api::BaseController
    before_action :set_todo, only: [:validate, :conflicts, :handle_deletion_error, :cancel_deletion, :destroy]
    before_action :doorkeeper_authorize!, except: [:cancel_deletion, :handle_deletion_error]
    before_action :doorkeeper_authorize!, only: [:create, :destroy]

    def create
      if params[:file_path] && params[:file_name]
        attach_file_to_todo
      else
        create_todo
      end
    end

    def validate
      # Implement validation logic here
    end

    def conflicts
      # Implement conflict checking logic here
    end

    def handle_deletion_error
      # Check if To-Do item exists and belongs to the current user
      unless @todo && TodoPolicy.new(current_resource_owner, @todo).destroy?
        return render json: { error: "To-Do item not found or not authorized." }, status: :not_found
      end

      # Call the service to handle deletion error
      result = TodoService::HandleDeletionError.new.call(@todo.id)

      if result[:success]
        render json: { status: 200, message: "Deletion error acknowledged." }, status: :ok
      else
        render json: { error: result[:error_message] }, status: :internal_server_error
      end
    end

    def cancel_deletion
      begin
        raise "Invalid To-Do item ID format." unless @todo.id.is_a?(Integer)
        result = TodoService::CancelDeletion.new(current_user, @todo.id).call
        if result[:success]
          render json: { status: 200, message: "Deletion canceled successfully." }, status: :ok
        else
          render json: { error: result[:error_message] }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "To-Do item not found." }, status: :not_found
      rescue Pundit::NotAuthorizedError
        render json: { error: "User does not have permission to cancel the deletion." }, status: :forbidden
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end

    def destroy
      begin
        todo_service = TodoService::Delete.new(current_resource_owner.id, @todo.id)
        todo_service.execute
        render json: { status: 200, message: 'To-Do item successfully deleted.' }, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      rescue Pundit::NotAuthorizedError => e
        render json: { error: e.message }, status: :forbidden
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end

    private

    def set_todo
      @todo = Todo.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'To-Do item not found.' }, status: :not_found
    end

    def create_todo
      begin
        todo_service = TodoService::Create.new(todo_params)
        result = todo_service.execute
        render json: { status: 201, todo: todo_params.merge(id: result[:id]) }, status: :created
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found.' }, status: :bad_request
      rescue ArgumentError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end

    def attach_file_to_todo
      todo_id = params[:todo_id]
      file_path = params[:file_path]
      file_name = params[:file_name]

      begin
        raise "File path is required." if file_path.blank?
        raise "File name is required." if file_name.blank?

        result = TodoService::AttachFile.new(
          todo_id: todo_id,
          file_path: file_path,
          file_name: file_name
        ).call

        if result[:id]
          render json: { status: 201, attachment: result }, status: :created
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      rescue => e
        render json: { error: e.message }, status: :bad_request
      end
    end

    def todo_params
      params.require(:todo).permit(
        :user_id,
        :title,
        :description,
        :due_date,
        :category,
        :priority,
        :is_recurring,
        :recurrence
      )
    end
  end
end
