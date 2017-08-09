class AddBittingToKeys < ActiveRecord::Migration
  def change
    add_column :keys, :bitting, :string
	add_column :keys, :system_name, :string
	rename_column :keys, :stamp_code, :operating_key
	add_column :keys, :comments, :text, :limit => 4294967295
  end
end
