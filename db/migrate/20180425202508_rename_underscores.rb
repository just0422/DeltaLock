class RenameUnderscores < ActiveRecord::Migration[5.0]
  def change
    rename_column :relationships, :end_user_id, :enduser_id
    rename_column :relationships, :purchase_order_id, :purchaseorder_id

    remove_column :purchase_orders, :end_user_id
    remove_column :purchase_orders, :purchaser_id
  end
end
