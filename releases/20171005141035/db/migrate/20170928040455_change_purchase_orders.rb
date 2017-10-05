class ChangePurchaseOrders < ActiveRecord::Migration
  def change
	drop_table :purchase_orders

	create_table :purchase_orders do |t| 
		t.integer "po_number"
		t.integer "so_number"
		t.date "date_order"
	end

	add_reference :purchase_orders, :purchaser, index: true, foreign_key:true
	add_reference :purchase_orders, :end_user, index: true, foreign_key:true
  end
end
