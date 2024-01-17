module TodoService
  class Create < BaseService
    attr_reader :user_id, :title, :description, :due_date, :category, :priority, :is_recurring, :recurrence

    def initialize(params)
      @user_id = params[:user_id]
      @title = params[:title]
      @description = params[:description]
      @due_date = params[:due_date]
      @category = params[:category]
      @priority = params[:priority]
      @is_recurring = params[:is_recurring]
      @recurrence = params[:recurrence]
    end

    def execute
      user = authenticate_user
      validate_title
      validate_due_date
      validate_priority
      validate_recurrence if is_recurring

      todo = user.todos.create!(
        title: title,
        description: description,
        due_date: due_date,
        category: category,
        priority: priority,
        is_recurring: is_recurring,
        recurrence: recurrence
      )

      { id: todo.id, message: 'Todo item created successfully' }
    end

    private

    def authenticate_user
      User.find(user_id)
    end

    def validate_title
      raise ArgumentError, 'Title cannot be blank' if title.blank?
      raise ArgumentError, 'Title has already been taken' if User.find(user_id).todos.exists?(title: title)
    end

    def validate_due_date
      raise ArgumentError, 'Due date must be in the future' unless due_date > Time.current
    end

    def validate_priority
      raise ArgumentError, 'Invalid priority' unless Todo.priorities.keys.include?(priority)
    end

    def validate_recurrence
      raise ArgumentError, 'Invalid recurrence' unless Todo.recurrences.keys.include?(recurrence)
    end
  end
end
