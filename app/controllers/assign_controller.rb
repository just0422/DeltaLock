class AssignController < ApplicationController
	respond_to :html, :js

	def index
		@categories = [ Purchaser, EndUser, PurchaseOrder, Key ]

		@categories = Hash.new
        @categories['purchaser'] = Purchaser
        @categories['enduser'] = EndUser
        @categories['purchaseorder'] = PurchaseOrder
        @categories['key'] = Key
	end
    
    def search
        @category = params[:type]

        case params[:type]
        when 'purchaser'
            @categoryName = "Purchaser"
            @categorySearch = Purchaser.search
        when 'enduser'
            @categoryName = "EndUser"
            @categorySearch = EndUser.search
        when 'purchaserorder'
            @categoryName = "PurchaseOrder"
            @categorySearch = PurchaseOrder.search
        when 'key'
            @categoryName = "Key"
            @categorySearch = Key.search
        end
    end
end
