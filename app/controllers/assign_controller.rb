class AssignController < ApplicationController
	respond_to :html, :js

	def index
		@categories = [ Purchaser, EndUser, PurchaseOrder, Key ]

		@categories = Hash.new
        @categories['purchaser'] = [ Purchaser, Purchaser.search]
        @categories['enduser'] = [ EndUser, EndUser.search]
        @categories['purchaseorder'] = [ PurchaseOrder, PurchaseOrder.search]
        @categories['key'] = [ Key, Key.search]
	end

end
