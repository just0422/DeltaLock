class MapController < ApplicationController
	before_action :set_enduser, only: [:show]
	respond_to :html, :js

	def index
        @enduser = EndUser.find(3)

		@end_users = EndUser.within(5000, :origin => @enduser[:address])
    end

	def show
		Rails.logger.debug(@enduser)
		if not params.key?("red")
			params[:red] = 25
			params[:yellow] = 50
		end

		@end_users_red = EndUser.within(params[:red], :origin => @enduser[:address]);
		@end_users_yellow = EndUser.in_range(params[:red]..params[:yellow], :origin => @enduser[:address]);
		@end_users_green = EndUser.beyond(params[:yellow], :origin => @enduser[:address]);
	end

	private 
	def set_enduser
		@enduser = EndUser.find(params[:id])
	end
end
