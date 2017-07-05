class RemoveAddressableFromPurchasers < ActiveRecord::Migration
  def change
	remove_foreign_key :end_users, :address
	remove_foreign_key :purchasers, :address

	drop_table :addresses

	add_column :end_users, :line1, :string
	add_column :end_users, :line2, :string
	add_column :end_users, :city, :string
	add_column :end_users, :state, :string
	add_column :end_users, :zip, :string
	add_column :end_users, :custom_address, :string

	add_column :purchasers, :line1, :string
	add_column :purchasers, :line2, :string
	add_column :purchasers, :city, :string
	add_column :purchasers, :state, :string
	add_column :purchasers, :zip, :string
	add_column :purchasers, :custom_address, :string
  end
end
