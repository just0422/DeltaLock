class AddGroupToPurchasers < ActiveRecord::Migration
  def change
#	  remove_column :end_users, :group_id
	  remove_column :purchasers, :group_id
#    add_column :end_users, :group, :string
#	add_column :purchasers, :group, :string
  end
end
