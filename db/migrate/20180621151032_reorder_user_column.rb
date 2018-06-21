class ReorderUserColumn < ActiveRecord::Migration[5.0]
  def change
      change_column :users, :username, :string, before: :email
      add_column :users, :first_name, :string, before: :username
      add_column :users, :last_name, :string, after: :first_name
  end
end
