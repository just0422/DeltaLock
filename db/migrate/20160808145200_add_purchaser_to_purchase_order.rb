class AddPurchaserToPurchaseOrder < ActiveRecord::Migration
  def change
    #remove_column :purchase_orders, :primary_key
    #remove_column :purchase_orders, :id
    #remove_column :purchase_orders, :so_number
    add_column :purchase_orders, :so_number, :primary_key
    add_reference :purchase_orders, :purchaser, index:true, foreign_key:true
    add_reference :purchase_orders, :end_user, index: true, foreign_key:true
  end
end
