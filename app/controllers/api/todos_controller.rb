
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

    def conflicts
      title = params[:title]
      due_date = params[:due_date]

      return render json: { error: "The title is required." }, status: :bad_request if title.blank?
      begin
        due_date = DateTime.parse(due_date)
      rescue ArgumentError
        return render json: { error: "Invalid due date format." }, status: :unprocessable_entity
      end

      result = TodoService.check_for_conflicting_todos(current_resource_owner.id, title, due_date)

      if result[:success]
        render json: { status: 200, conflicts: [] }, status: :ok
      else
        render json: { status: 409, conflicts: Todo.where(user_id: current_resource_owner.id, title: title, due_date: due_date) }, status: :conflict
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
