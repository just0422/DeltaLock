class CreatePurchasers < ActiveRecord::Migration
  def change
    create_table :purchasers do |t|
      t.string :name
      t.string :address
      t.string :email
      t.string :phone
      t.string :fax
      t.timestamps null: false
    end
  end
end
