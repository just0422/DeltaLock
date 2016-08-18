class AddLocationToEndUser < ActiveRecord::Migration
  def change
	  add_column :end_users, :lat, :float
	  add_column :end_users, :lng, :float
  end
end
