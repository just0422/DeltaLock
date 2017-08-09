class CreateAddresses < ActiveRecord::Migration
  def change
#    create_table :addresses do |t|
#		t.string :line1
#		t.string :line2
#		t.string :city
#		t.string :state
#		t.string :zip
#		t.string :country
#		t.text :custom_address
#		t.integer :addressable_id
#		t.string :addressable_type
#				   
#		t.timestamps
#	end
 
#	add_index :addresses, [:addressable_type, :addressable_id], :unique => true

#	remove_column :purchasers, :email
#	remove_column :purchasers, :address
#	add_column :purchasers, :primary_contact, :string
#	add_column :purchasers, :primary_contact_type, :string
#	add_column :purchasers, :group_id, :int
#	add_column :purchasers, :address_id, :int
#	add_foreign_key "purchasers", "groups"
#	add_foreign_key "purchasers", "addresses"

#	remove_column :end_users, :email
#	remove_column :end_users, :address
#	add_column :end_users, :primary_contact, :string
#	add_column :end_users, :primary_contact_type, :string
#	add_column :end_users, :sub_department_1, :string
#	add_column :end_users, :sub_department_2, :string
#	add_column :end_users, :sub_department_3, :string
#	add_column :end_users, :sub_department_4, :string
	add_column :end_users, :address_id, :int
	add_foreign_key "end_users", "addresses"

	rename_column :keys, :key, :keyway

  end
end
