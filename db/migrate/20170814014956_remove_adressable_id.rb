class RemoveAdressableId < ActiveRecord::Migration
  def change
	  change_table :end_users do |t|
		  t.string :line1, :line2, :city, :state, :zip, :country
		  t.text :custom_address
	  end

	  change_table :purchasers do |t|
		  t.string :line1, :line2, :city, :state, :zip, :country
		  t.text :custom_address
	  end
  end
end
