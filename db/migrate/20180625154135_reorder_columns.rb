class ReorderColumns < ActiveRecord::Migration[5.0]
  def change
      change_column :keys, :system_name, :string, after: :keyway
      change_column :keys, :keyway, :string, after: :system_name

      change_column :users, :first_name, :string, after: :email
      change_column :users, :last_name, :string, after: :first_name
  end
end
