class EndUserController < ApplicationController
	before_action :set_enduser, only: [:show, :show_enduser, :edit, :update]
	after_action :set_session
	respond_to :html, :js

	def show
        @purchase_orders_list = PurchaseOrder.where("end_user_id like ?", "%#{params[:id]}%")
    end
	
	def show_enduser
		render partial: "enduserinfo"
		@address_attributes = Address.find_by_addressable_id(params[:id])
	end
	
	def update
		geo = EndUser.geocode(build_address_string(params[:end_user][:address_attributes]))
		@enduser[:lat] = geo.lat
		@enduser[:lng] = geo.lng

		@enduser.update_attributes(enduser_params)
	end
	
	def new 
		@enduser = EndUser.new
		@enduser.build_address
	end

	def create
		if not Group.exists?(id: params[:end_user][:group_id])
			Group.create(id: params[:end_user][:group_id])
		end

		geo = EndUser.geocode(build_address_string(params[:end_user][:address_attributes]))
		params[:end_user][:lat] = geo.lat
		params[:end_user][:lng] = geo.lng

		@enduser = EndUser.create(enduser_params)
	end

	private
	def enduser_params
		params.require(:end_user).permit(:name, :phone, :fax, :primary_contact, :primary_contact_type, :department, :store_number, :group_id, :lat, :lng, :sub_department_1, :sub_department_2, :sub_department_3, :sub_department_4, address_attributes: [:line1, :line2, :city, :state, :zip, :country, :custom_address])
	end

	def set_session
		session[:enduser] = @enduser[:id]
		session[:group_id] = @enduser[:group_id]
	end

	def set_enduser
		@enduser = EndUser.find(params[:id])
	end

	def check_group_and_address
		if not Group.exists?(id: params[:end_user][:group_id])
			Group.create(id: params[:end_user][:group_id])
		end
	end
end
