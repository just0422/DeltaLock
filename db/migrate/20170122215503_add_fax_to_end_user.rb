class AddFaxToEndUser < ActiveRecord::Migration
  def change
    add_column :end_users, :fax, :string
  end
end
