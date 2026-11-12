class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    add_column :users, :contact, :string
    add_column :users, :comment, :text
  end
end
