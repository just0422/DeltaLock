class KeyController < ApplicationController
	before_action :set_key, only: [:show, :edit, :update]
	after_action :set_session, only:[:set_key, :create]
	respond_to :html, :js

	def show
		@end_users_list = Array.new

        @pok = PoK.find_by_key_id(@key[:key_hash])

		@matching_keys = Key.where("master_key like ?", "%#{val}%")
		@matching_keys += Key.where("control_key like ?", "%#{val}%")
		@matching_keys += Key.where("key like ?", "%#{val}%")

		@matching_keys = @matching_keys.uniq.compact
		
		@matchin_keys.each do |key|
			pok = PoK.find_by_key_id(key[:key_hash])
			po = PurchaseOrder.find(PoK[:purchase_order_id])
			@end_users_list += EndUser.find(po[:end_user_id])
		end
		# find all end users associated with each keys
		# return all end users
		#
		# if end users is empty
		#   continue as before
		# else
		# 	render maps page
		
    end

	def update
		@key.update_attributes(key_params)
	end
	
	def new
		@key = Key.new
	end

	def create
		@key = Key.new(key_params)

		@key_columns = "<thead><tr>"
		@key_info = "<tbody><tr>"
		Key.column_names.each do |title|
			@key_columns += "<th>" + title + "</th>"
			@key_info += "<td>" + @key[title].to_s + "</td>"
		end
		@key_columns += "</tr></thead>"
		@key_info += "</tr></tbody"

	end

	private
	def key_params
		params.require(:key).permit(:key, :master_key, :control_key, :stamp_code)
	end

	def set_session
		session[:key] = @key[:id]
	end

	def set_key
		@key = Key.find(params[:id])
	end
end
