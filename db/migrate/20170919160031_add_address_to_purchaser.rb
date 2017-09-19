class AddAddressToPurchaser < ActiveRecord::Migration
  def change
	  change_table :end_users do |t|
		  t.remove :line2, :city, :state, :zip, :country, :custom_address
		  t.text :address
	  end
	  change_table :purchasers do |t|
		  t.remove :line2, :city, :state, :zip, :country, :custom_address
		  t.text :address
	  end
  end
end
