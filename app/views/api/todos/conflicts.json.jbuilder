json.status @status
json.conflicts @conflicts do |conflict|
  json.id conflict.id
  json.title conflict.title
  json.due_date conflict.due_date.iso8601
end

