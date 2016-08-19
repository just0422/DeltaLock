class EndUserController < ApplicationController
	before_action :set_enduser, only: [:show, :edit, :update]
	respond_to :html, :js

	def show 
        @purchase_orders_list = PurchaseOrder.where("end_user_id like ?", "%#{params[:id]}%")
    end
	
	def update
		geo = EndUser.geocode(params[:end_user][:address])
		@enduser[:lat] = geo.lat
		@enduser[:lng] = geo.lng

		@enduser.update_attributes(enduser_params)
	end

	private
	def enduser_params
		params.require(:end_user).permit(:name, :email, :address, :phone, :department, :store_number, :group)
	end

	def set_enduser
		@enduser = EndUser.find(params[:id])
	end
end
