class AllController < ApplicationController
	def index
		@endusers = EndUser.all
	end
end
