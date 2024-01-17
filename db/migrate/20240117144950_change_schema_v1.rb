class ChangeSchemaV1 < ActiveRecord::Migration[6.0]
  def change
    create_table :users, comment: 'Stores user account information' do |t|
      t.string :name

      t.timestamps null: false
    end

    create_table :attachments, comment: 'Stores attachments associated with todo items' do |t|
      t.string :file_path

      t.string :file_name

      t.timestamps null: false
    end

    create_table :todos, comment: 'Stores todo items created by users' do |t|
      t.string :category

      t.boolean :is_recurring

      t.datetime :due_date

      t.integer :recurrence, default: 0

      t.integer :priority, default: 0

      t.text :description

      t.string :title

      t.timestamps null: false
    end

    add_reference :attachments, :todo, foreign_key: true

    add_reference :todos, :user, foreign_key: true
  end
end
