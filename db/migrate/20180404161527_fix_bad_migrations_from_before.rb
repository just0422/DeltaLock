class FixBadMigrationsFromBefore < ActiveRecord::Migration[5.0]
    def change
        remove_foreign_key :end_users, :addresses
        remove_foreign_key :end_users, :groups


        change_table :end_users do |t|
            t.remove :email
            t.remove :line1
            t.remove :address_id
            t.remove :group_id
            t.remove :address

            t.string :group_name, after: :fax
            t.string :primary_contact
            t.string :primary_contact_type
            t.string :sub_department_1
            t.string :sub_department_2
            t.string :sub_department_3
            t.string :sub_department_4
            t.text :address, limit: 65535

            t.change :lat, :float, after: :sub_department_4
            t.change :lng, :float, after: :lat
            t.change :address, :string, after: :lng
            t.change :updated_at, :datetime, after: :name
            t.change :created_at, :datetime, after: :name
            t.change :name, :string, after: :updated_at
            t.change :fax, :string, after: :phone

        end

        add_index :end_users, :id

        drop_table "addresses" do |t|
            t.string :name
        end

        drop_table "groups" do |t|
            t.string :name
        end

        change_table :keys do |t|
            t.change :updated_at, :datetime, after: :keyway
            t.change :created_at, :datetime, after: :keyway

        end

        add_index :keys, :id

        drop_table "po_ks" do |t|
            t.integer :quantity
        end

        remove_foreign_key "purchase_orders", "end_users"
        remove_foreign_key "purchase_orders", "purchasers"

        add_index :purchase_orders, :id

        change_table :purchasers do |t|
            t.remove :address
            t.remove :line2
            t.remove :city
            t.remove :state
            t.remove :zip
            t.remove :country
            t.remove :custom_address

            t.change :updated_at, :datetime, after: :name
            t.change :created_at, :datetime, after: :name
            t.change :name, :string, after: :updated_at

            t.string :primary_contact
            t.string :primary_contact_type
            t.string :group_name
            t.text :address, limit: 65535
        end

        add_index :purchasers, :id
    end
end
