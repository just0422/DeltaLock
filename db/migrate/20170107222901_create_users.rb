class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.timestamps null: false
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password_digest

	  t.string :role
    end
  end
end
