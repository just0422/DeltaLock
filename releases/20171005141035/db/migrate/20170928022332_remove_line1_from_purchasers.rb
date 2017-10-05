class RemoveLine1FromPurchasers < ActiveRecord::Migration
  def change
	  remove_column :purchasers, :line1
  end
end
