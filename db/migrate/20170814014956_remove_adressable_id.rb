class RemoveAdressableId < ActiveRecord::Migration
  def change
	  remove_foreign_key "purchasers", "addresses"
	  remove_foreign_key "end_users", "addresses"
	  drop_table :addresses

	  change_table :end_users do |t|
		  t.remove :address_id
		  t.string :line1, :line2, :city, :state, :zip, :country
		  t.text :custom_address
	  end

	  change_table :purchasers do |t|
		  t.remove :address_id
		  t.string :line1, :line2, :city, :state, :zip, :country
		  t.text :custom_address
	  end
  end
end
