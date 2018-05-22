class RemoveExtraColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :end_users, :line2
    remove_column :end_users, :city
    remove_column :end_users, :state
    remove_column :end_users, :country
    remove_column :end_users, :custom_address

    change_column :end_users, :address, :text, after: :store_number
    change_column :purchasers, :address, :text, after: :fax
  end
end
