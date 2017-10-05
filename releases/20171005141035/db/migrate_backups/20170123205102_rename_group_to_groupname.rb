class RenameGroupToGroupname < ActiveRecord::Migration
  def change
	  rename_column :end_users, :group, :group_name
	  rename_column :purchasers, :group, :group_name
  end
end
