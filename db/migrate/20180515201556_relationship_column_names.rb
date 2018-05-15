class RelationshipColumnNames < ActiveRecord::Migration[5.0]
  def change
    rename_column :relationships, :purchaseorder_id, :purchaseorders
    rename_column :relationships, :purchaser_id, :purchasers
    rename_column :relationships, :enduser_id, :endusers
    rename_column :relationships, :key_id, :keys
  end
end
