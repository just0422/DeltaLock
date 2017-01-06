class PurchaserController < ApplicationController
	before_action :set_purchaser, only: [:show, :edit, :update]
	after_action :set_session, only: [:set_purchaser, :create]
	respond_to :html, :js

	def show 
        @purchase_orders_list = PurchaseOrder.where("purchaser_id like ?", "%#{params[:id]}%")
    end

	def update
		@purchaser.update_attributes(purchaser_params)
	end

	def new
		@purchaser = Purchaser.new
	end

	def create
		@purchaser = Purchaser.create(purchaser_params)

		@purchaser_columns = "<thead><tr>"
		@purchaser_info = "<tbody><tr>"
		Purchaser.column_names.each do |title|
			@purchaser_columns += "<th>" + title + "</th>"
			@purchaser_info += "<td>" + @purchaser[title].to_s + "</td>"
		end
		@purchaser_columns += "</tr></thead>"
		@purchaser_info += "</tr></tbody>"

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
