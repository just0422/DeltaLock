class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
	drop_table :relationship
    create_table :relationships do |t|
      t.integer :purchase_order_id
      t.integer :purchaser_id
      t.integer :end_user_id
      t.integer :key_id
      t.timestamps
    end
  end
end
