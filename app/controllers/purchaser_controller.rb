class PurchaserController < ApplicationController
	before_action :set_purchaser, only: [:show, :edit, :update]
	respond_to :html, :js

	def show 
        @purchase_orders_list = PurchaseOrder.where("purchaser_id like ?", "%#{params[:id]}%")
    end

	def update
		@purchaser.update_attributes(purchaser_params)
	end


	private
	def purchaser_params
		params.require(:purchaser).permit(:name, :address, :email, :phone, :fax)
	end

	def set_purchaser
        @purchaser = Purchaser.find(params[:id])
	end
end
