module Api
  class TodosController < Api::BaseController
    before_action :doorkeeper_authorize!

    def create
      if params[:file_path] && params[:file_name]
        attach_file_to_todo
      else
        create_todo
      end
    end

    private

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
