class AddIdToPurchaseOrders < ActiveRecord::Migration
  def change
	  change_table :purchase_orders, id: true do |t|
		  t.remove :so_number
		  t.integer :id, primary_key: true
		  t.integer :so_number
	  end
	  change_table :purchasers, id: true do |t|
		  t.remove :so_number
		  t.integer :id, primary_key: true
	  end
  end
end
