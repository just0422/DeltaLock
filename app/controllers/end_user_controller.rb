class EndUserController < ApplicationController
	before_action :set_enduser, only: [:show, :show_enduser, :edit, :update]
	after_action :set_session, only: [:set_enduser, :create]
	respond_to :html, :js

	def show
        @purchase_orders_list = PurchaseOrder.where("end_user_id like ?", "%#{params[:id]}%")
    end
	
	def show_enduser
		render partial: "enduserinfo"
	end
	
	def update
		geo = EndUser.geocode(params[:end_user][:address])
		@enduser[:lat] = geo.lat
		@enduser[:lng] = geo.lng

		@enduser.update_attributes(enduser_params)
	end
	
	def new 
		@enduser = EndUser.new
	end

	def create
		if not Group.exists?(id: params[:end_user][:group_id])
			Group.create(id: params[:end_user][:group_id])
		end
	
		geo = EndUser.geocode(params[:end_user][:address])
		params[:end_user][:lat] = geo.lat
		params[:end_user][:lng] = geo.lng

		@enduser = EndUser.create(enduser_params)
	end

	private
	def enduser_params
		params.require(:end_user).permit(:name, :email, :address, :phone, :department, :store_number, :group_id, :lat, :lng)
	end

	def set_session
		session[:enduser] = @enduser[:id]
		session[:group_id] = @enduser[:group_id]
	end

	def set_enduser
		@enduser = EndUser.find(params[:id])
	end
end
