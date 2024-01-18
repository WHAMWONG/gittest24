class ToDoItem < ApplicationRecord
  belongs_to :folder

  enum status: %w[pending completed overdue], _suffix: true

  # validations

  # end for validations

  class << self
  end
end
