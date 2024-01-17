json.status 201
json.todo do
  json.id @todo.id
  json.user_id @todo.user_id
  json.title @todo.title
  json.description @todo.description
  json.due_date @todo.due_date.iso8601
  json.category @todo.category
  json.priority @todo.priority
  json.is_recurring @todo.is_recurring
  json.recurrence @todo.recurrence
end
