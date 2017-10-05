class MapController < ApplicationController
	before_action :set_enduser, only: [:show, :map]
	respond_to :html, :js

	def index
        @enduser = EndUser.find(3)

		@end_users = EndUser.within(5000, :origin => @enduser[:address])
    end

	def map
		if not params.key?("red")
			params[:red] = 25
			params[:yellow] = 50
			params[:green] = 100
		end

		if Integer(params[:yellow]) > Integer(params[:green])
			params[:green] = params[:yellow]
		end
		
		#puts session[:enduser]
		#puts session[:group_name]
		#		end_user_group = EndUser.where(group_id: params[:group])
		end_user_group = EndUser.where(group_name: session[:group_name])
		#address_attributes = Address.find_by_addressable_id_and_addressable_type(params[:id], "EndUser")

		@end_users_red = end_user_group.within(params[:red], :origin => build_address_string(address_attributes));
		@end_users_yellow = end_user_group.in_range(params[:red]..params[:yellow], :origin => build_address_string(address_attributes));
		@end_users_green = end_user_group.beyond(params[:yellow], :origin => build_address_string(address_attributes));

		#puts end_user_group
	
		@end_users_red.to_a.delete(@enduser)	
		@end_users_yellow.to_a.delete(@enduser)	
		@end_users_green.to_a.delete(@enduser)	

		@red_key_codes = get_associated_keys(@end_users_red)
		@yellow_key_codes = get_associated_keys(@end_users_yellow)
		@green_key_codes = get_associated_keys(@end_users_green)

#		puts "Red"
#		puts @end_users_red
#		puts @red_key_codes
#		puts "Green"
#		puts @end_users_green
#		puts @green_key_codes
#		puts "Yellow"
#		puts @end_users_yellow
#		puts @yellow_key_codes
		#render :partial => "map"
		respond_to do |format|
#			#format.html { redirect_to @user, notice: "Successfully updated user." }
#			format.js
			format.html { render :partial => "keymap" }
#			#render(:partial => "map")
		end
	end

	def show
		if not params.key?("red")
			params[:red] = 25
			params[:yellow] = 50
			params[:green] = 100
		end

		if Integer(params[:yellow]) > Integer(params[:green])
			params[:green] = params[:yellow]
		end
		
		end_user_group = EndUser.where(group_id: params[:group])

		@end_users_red = end_user_group.within(params[:red], :origin => @enduser[:address]);
		@end_users_yellow = end_user_group.in_range(params[:red]..params[:yellow], :origin => @enduser[:address]);
		@end_users_green = end_user_group.beyond(params[:yellow], :origin => @enduser[:address]);
		
		@end_users_red.to_a.delete(@enduser)	
		@end_users_yellow.to_a.delete(@enduser)	
		@end_users_green.to_a.delete(@enduser)	

		@red_key_codes = get_associated_keys(@end_users_red)
		@yellow_key_codes = get_associated_keys(@end_users_yellow)
		@green_key_codes = get_associated_keys(@end_users_green)
	end

	private 
	def set_enduser
		@enduser = EndUser.find(session[:enduser])
#		@enduser = EndUser.find(params[:id])
	end

	def get_associated_keys(endusers)
		keycodes = Array.new
		endusers.each do |eu|
			purchase_orders = PurchaseOrder.where("end_user_id like?", "%#{eu[:id]}")
			purchase_orders.each do |po|
				poks = PoK.where(purchase_order_id: po[:so_number])

				poks.each do |pok|
					key = Key.find(pok[:key_id])
					keycodes.push(key)
				end
			end
		end
		return keycodes
	end
end
