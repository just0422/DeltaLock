class EndUserController < ApplicationController
	before_action :set_enduser, only: [:show, :edit, :update]
	before_action :set_purchaseorder_list, only: [:show] 
	respond_to :html, :js

	def show 
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
		@enduser = EndUser.create(enduser_params)

		@enduser_columns = "<thead><tr>"
		@enduser_info = "<tbody><tr>"
		EndUser.column_names.each do |title|
			@enduser_columns += "<th>" + title + "</th>"
			@enduser_info += "<td>" + @enduser[title].to_s + "</td>"
		end
		@enduser_columns += "</tr></thead>"
		@enduser_info += "</tr></tbody"
	end

	private
	def enduser_params
		params.require(:end_user).permit(:name, :email, :address, :phone, :department, :store_number, :group)
	end

	def set_enduser
		@enduser = EndUser.find(params[:id])
	end

	def set_purchaseorder_list
        @purchase_orders_list = PurchaseOrder.where("end_user_id like ?", "%#{params[:id]}%")
	end

end
