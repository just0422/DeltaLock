class RemovePrimaryKeyFromKeys < ActiveRecord::Migration
  def change
      remove_column :keys, :key_hash
      add_column :keys, :key_hash, :primary_key
  end
end
