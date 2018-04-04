class AddCustomAddressToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :custom_address, :string
  end
end
