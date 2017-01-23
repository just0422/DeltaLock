class PurchaserController < ApplicationController
	before_action :set_purchaser, only: [:show, :show_purchaser, :edit, :update]
	after_action :set_session, only: [:set_purchaser, :create]
	respond_to :html, :js

	def show 
        @purchase_orders_list = PurchaseOrder.where("purchaser_id like ?", "%#{params[:id]}%")
    end

	def show_purchaser
		render partial: "purchaserinfo"
	end

	def update
		@purchaser.update_attributes(purchaser_params)
	end

	def new
		@purchaser = Purchaser.new
		@purchaser.build_address
	end

	def create
		@purchaser = Purchaser.create(purchaser_params)
	end


	private
	def purchaser_params
		params.require(:purchaser).permit(:name, :address, :email, :phone, :fax)
	end

	def set_session
		session[:purchaser] = @purchaser[:id]
	end

	def set_purchaser
        @purchaser = Purchaser.find(params[:id])
	end
end
