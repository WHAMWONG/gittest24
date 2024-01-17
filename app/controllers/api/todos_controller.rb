module Api
  class TodosController < Api::BaseController
    before_action :doorkeeper_authorize!

    def create
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

    private

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
