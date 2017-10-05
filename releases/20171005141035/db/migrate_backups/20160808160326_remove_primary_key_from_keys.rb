class RemovePrimaryKeyFromKeys < ActiveRecord::Migration
  def change
      #remove_column :keys, :key_hashi
	  remove_column :keys, :id
	  remove_column :keys, :primary_key
      add_column :keys, :key_hash, :primary_key
  end
end
