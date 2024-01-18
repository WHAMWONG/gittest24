json.status 201
json.folder do
  json.id @folder.id
  json.user_id @folder.user_id
  json.name @folder.name
  json.color @folder.color
  json.icon @folder.icon
  json.created_at @folder.created_at
  json.updated_at @folder.updated_at
end
