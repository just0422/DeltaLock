class RemoveAddressId < ActiveRecord::Migration
  def change
	remove_column :end_users, :address_id
	remove_column :purchasers, :address_id
  end
end
