class AddColumnsToKey < ActiveRecord::Migration[5.0]
  def change
      remove_column :users, :username

      add_column :keys, :keycode_stamp, :string
      add_column :keys, :bitting_driver, :string
      add_column :keys, :bitting_control, :string
      add_column :keys, :bitting_master, :string
      add_column :keys, :bitting_bottom, :string

      remove_column :keys, :bitting

      change_column :keys, :system_name, :string, before: :keyway
      change_column :keys, :comments, :text, after: :bitting_bottom
  end
end
