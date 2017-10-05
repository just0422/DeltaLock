class CreateEndUsers < ActiveRecord::Migration
  def change
    create_table :end_users do |t|
      t.string :name
      t.string :address
      t.string :email
      t.string :phone
      t.string :department
      t.integer :store_number

      t.timestamps null: false
    end
  end
end
