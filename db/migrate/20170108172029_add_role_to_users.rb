class AddRoleToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :fieldname, :string
    add_column :users, :role, :string
  end
end
