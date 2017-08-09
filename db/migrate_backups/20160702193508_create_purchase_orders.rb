class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.integer :so_number, :primary_key
      t.integer :po_number
      t.date :date_order

      t.timestamps null: false
    end
  end
end
