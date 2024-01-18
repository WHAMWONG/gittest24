class ChangeSchemaV3 < ActiveRecord::Migration[6.0]
  def change
    create_table :to_do_items do |t|
      t.string :title

      t.datetime :due_date

      t.text :description

      t.integer :status, default: 0

      t.timestamps null: false
    end

    create_table :folders do |t|
      t.string :icon

      t.string :color

      t.string :name

      t.timestamps null: false
    end

    change_table_comment :users, from: 'Stores user account information', to: ''

    add_reference :to_do_items, :folder, foreign_key: true

    add_reference :folders, :user, foreign_key: true
  end
end
