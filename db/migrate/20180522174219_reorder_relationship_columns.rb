class ReorderRelationshipColumns < ActiveRecord::Migration[5.0]
  def change
    change_column :relationships, :endusers, :integer, after: :keys
    change_column :relationships, :purchasers, :integer, after: :endusers
    change_column :relationships, :purchaseorders, :integer, after: :purchasers
  end
end
