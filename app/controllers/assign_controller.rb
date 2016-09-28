class AssignController < ApplicationController
	respond_to :html, :js

	def index
		@purchaseorder = PurchaseOrder.new
	end

end
