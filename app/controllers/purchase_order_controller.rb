require 'json'

class PurchaseOrderController < ApplicationController
	before_action :set_purchaseorder, only: [:show, :edit, :update]
	respond_to :html, :js
	
	def show
        @purchaser = Purchaser.find(@purchaseorder[:purchaser_id])
        @end_user = EndUser.find(@purchaseorder[:end_user_id])
        
        poks = PoK.where(purchase_order_id: params[:id])
        @keys_list = Array.new

        poks.each do |po_k|
            @keys_list.push(Key.find(po_k[:key_id]))
        end
    end

	def update
		@purchaseorder.update_attributes(purchaseorder_params)
	end

	def new
		@purchaseorder = PurchaseOrder.new
	end

	def create
		purchaseorder = params["purchaseorder-information"]
		purchaser = params["purchaser-information"]
		enduser = params["enduser-information"]
		key = params["key-information"]

		purchaser = JSON.parse purchaser
		enduser = JSON.parse enduser
		key = JSON.parse key
		params["purchase_order"] = JSON.parse purchaseorder

		@purchaseorder = PurchaseOrder.new(purchaseorder_params)
		@purchaseorder[:end_user_id] = enduser["id"]
		@purchaseorder[:purchaser_id] = purchaser["id"]
		@purchaseorder.save
		
		params["pok"] = {
			"quantity" => 0, 
			"key_id" => key["key_hash"],
			"purchase_order_id" => @purchaseorder["so_number"]
		}
		@pok = PoK.new(pok_params)
		@pok.save
		
#			:so_number => purchaseorder["so_number"], 
#			:po_number => purchaseorder["po_number"], 
#			:date_order => purchaseorder["date_order"], 
		

		Rails.logger.debug(purchaseorder)
	end

	private
	def purchaseorder_params
		params.require(:purchase_order).permit(:po_number, :date_order, :so_number)
	end
	def pok_params
		params.require(:pok).permit(:quantity, :key_id, :purchase_order_id)
	end

	def set_purchaseorder
		@purchaseorder = PurchaseOrder.find(params[:id])
	end
end
