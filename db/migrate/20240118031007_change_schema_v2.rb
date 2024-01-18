class ChangeSchemaV2 < ActiveRecord::Migration[6.0]
  def change
    change_table_comment :todos, from: 'Stores todo items created by users', to: 'Stores To-Do items for users'

    add_column :todos, :is_completed, :boolean

    add_column :users, :password_hash, :string

    add_column :users, :username, :string

    add_column :todos, :deleted_at, :datetime

    add_column :users, :email, :string
  end
end
