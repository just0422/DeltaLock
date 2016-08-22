class MapController < ApplicationController
	before_action :set_enduser, only: [:show]
	respond_to :html, :js

	def index
        @enduser = EndUser.find(3)

		@end_users = EndUser.within(5000, :origin => @enduser[:address])
    end

	def show
		if not params.key?("red")
			params[:red] = 25
			params[:yellow] = 50
		end

		if Integer(params[:yellow]) > 100
			params[:max] = params[:yellow]
		else
			params[:max] = 100
		end

		@end_users_red = EndUser.within(params[:red], :origin => @enduser[:address]);
		@end_users_yellow = EndUser.in_range(params[:red]..params[:yellow], :origin => @enduser[:address]);
		@end_users_green = EndUser.beyond(params[:yellow], :origin => @enduser[:address]);

		@red_key_codes = get_associated_keys(@end_users_red)
		@yellow_key_codes = get_associated_keys(@end_users_yellow)
		@green_key_codes = get_associated_keys(@end_users_green)

	end

	private 
	def set_enduser
		@enduser = EndUser.find(params[:id])
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
