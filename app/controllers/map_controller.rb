class MapController < ApplicationController
	before_action :set_enduser, only: [:show]
	respond_to :html, :js

	def index
        @enduser = EndUser.find(3)

		@end_users = EndUser.within(5000, :origin => @enduser[:address])
    end

	def show
	end

	private 
	def set_enduser
		@enduser = EndUser.find(params[:id])
	end
end
