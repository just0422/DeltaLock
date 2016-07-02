class CreatePoKs < ActiveRecord::Migration
  def change
    create_table :po_ks do |t|
      t.integer :quanitity      
      t.belongs_to :key, index: true
      t.belongs_to :purchase_order, index: true

      t.timestamps null: false
    end
  end
end
