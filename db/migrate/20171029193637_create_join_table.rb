class CreateJoinTable < ActiveRecord::Migration[5.0]
	def change
		create_table :relationship do |t|
			t.integer :purchase_order_id
			t.integer :purchaser_id
			t.integer :end_user_id
			t.integer :key_id
		end
		

		add_index(:purchase_orders, :id)
		add_index(:purchasers, :id)
		add_index(:end_users, :id)
		add_index(:keys, :id)

		remove_foreign_key(:purchase_orders, :end_users)
		remove_foreign_key(:purchase_orders, :purchasers)

		remove_index(:purchase_orders, :end_user_id)
		remove_index(:purchase_orders, :purchaser_id)

		remove_index(:po_ks, :key_id)
		remove_index(:po_ks, :purchase_order_id)

		drop_table :po_ks
	end
end
