class AddIdToKeys < ActiveRecord::Migration
  def change
	#execute "ALTER TABLE `keys` DROP PRIMARY KEY"
    rename_column :keys, :key_hash, :id
  end
end
