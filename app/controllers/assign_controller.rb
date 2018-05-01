class AssignController < ApplicationController
	before_action :set_variables, only: [:create, :new]
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

    def new
        @entry = @class.new
    end

    def create
        case params[:type]
        when "key"
            @entry = Key.create(key_parameters)
        when "enduser"
            geo = EndUser.geocode(params[:address])
            params[:lat] = geo.lat
            params[:lng] = geo.lng

            @entry = EndUser.create(enduser_parameters)
        when "purchaser"
            @entry = Purchaser.create(purchaser_parameters)
        when "purchaseorder"
            @entry = PurchaseOrder.create(purchaseorder_parameters)
        end
    end

    private
	def set_variables
		case params[:type]
		when "key"
			@class = Key
		when "enduser"
			@class = EndUser
		when "purchaser"
			@class = Purchaser
		when "purchaseorder"
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
