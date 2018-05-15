class AssignController < ApplicationController
	before_action :set_variables, only: [:create, :new, :search]
	respond_to :html, :js

	def index
		@categories = [ Purchaser, EndUser, PurchaseOrder, Key ]

		@categories = Hash.new
        @categories['purchaser'] = Purchaser
        @categories['enduser'] = EndUser
        @categories['purchaseorder'] = PurchaseOrder
        @categories['key'] = Key
	end
    
    def new
        @entry = @class.new
    end

    def create
        case params[:type]
        when "keys"
            @entry = Key.create(key_parameters)
        when "endusers"
            geo = EndUser.geocode(params[:address])
            params[:lat] = geo.lat
            params[:lng] = geo.lng

            @entry = EndUser.create(enduser_parameters)
        when "purchasers"
            @entry = Purchaser.create(purchaser_parameters)
        when "purchaseorders"
            @entry = PurchaseOrder.create(purchaseorder_parameters)
        end
    end

    def search
        @category = params[:type]

        case params[:type]
        when 'purchasers'
            @categoryName = "Purchaser"
            @categorySearch = Purchaser.search
        when 'endusers'
            @categoryName = "EndUser"
            @categorySearch = EndUser.search
        when 'purchaserorders'
            @categoryName = "PurchaseOrder"
            @categorySearch = PurchaseOrder.search
        when 'keys'
            @categoryName = "Key"
            @categorySearch = Key.search
        end
    end

    def result
        case params[:search_type]
        when "purchaseorders"
            @class = PurchaseOrder
            @name = "Purchase Orders"
        when "keycodes"
            @class = Key
            @name = "Key Codes"
        when "endusers"
            @class = EndUser
            @name = "End Users"
        when "purchasers"
            @class = Purchaser
            @name = "Purchasers"
        end
        
        @css_class = params[:search_type]
        @search = @class.search(params[:q])
        @list = @search.result

        respond_to do |format|
            format.js
        end
    end

    def assignment
        respond_to do |format|
            format.js
        end
    end

    private
	def set_variables
		case params[:type]
		when "keys"
			@class = Key
		when "endusers"
			@class = EndUser
		when "purchasers"
			@class = Purchaser
		when "purchaseorders"
			@class = PurchaseOrder
		end
		@id = params[:id]
		@type = params[:type]
	end

	def enduser_parameters
		params.permit(:name, :address, :phone, :fax, :primary_contact, :primary_contact_type, :department, :store_number, :group_name, :lat, :lng, :sub_department_1, :sub_department_2, :sub_department_3, :sub_department_4)
	end

	def purchaser_parameters
		params.permit(:name, :address, :email, :phone, :fax, :primary_contact, :primary_contact_type, :group_name)
	end

	def purchaseorder_parameters
		params.permit(:po_number, :date_order, :so_number)
	end

	def key_parameters
		params.permit(:keyway, :master_key, :control_key, :operating_key, :bitting, :system_name, :comments)
	end
end
