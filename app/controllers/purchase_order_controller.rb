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
		purchaser = params[:purchaser]
		enduser = params[:enduser]

		keys = Array.new
	end

	private
	def purchaseorder_params
		params.require(:purchase_order).permit(:po_unmber, :date_order, :so_number)
	end

	def set_purchaseorder
		@purchaseorder = PurchaseOrder.find(params[:id])
	end
end
