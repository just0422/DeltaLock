class AssignController < ApplicationController
	respond_to :html, :js

	def index
		@categories = [ Purchaser, EndUser, PurchaseOrder, Key ]

		@purchaseorder = PurchaseOrder.new
	end

end
