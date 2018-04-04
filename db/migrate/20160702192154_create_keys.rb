class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.string         :key         # Ex. 1AA, 2AA, etc.
      t.string         :master_key  # Ex. Sterling Jewelers
      t.string         :control_key # Ex. 2241564
      t.string         :stamp_code
      
      t.timestamps null: false
    end
  end
end
