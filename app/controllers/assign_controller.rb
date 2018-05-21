class AssignController < ApplicationController
	before_action :set_variables, only: [:create, :new, :search]

	def index
		@categories = [ Purchaser, EndUser, PurchaseOrder, Key ]

		@categories = Hash.new
        @categories['purchasers'] = Purchaser
        @categories['endusers'] = EndUser
        @categories['purchaseorders'] = PurchaseOrder
        @categories['keys'] = Key
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
        when 'purchaseorders'
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
        Relationship.create(assignment_parameters)

        @assignment_parts = ManageData.assign_parts(params)
    end

    def manage
        @assignments = Array.new
        list = Relationship.all

        list.each do |assignment|
            assigned_parts = Hash.new
            assigned_parts[:data] = ManageData.assign_parts(assignment)
            assigned_parts[:id] = assignment[:id]
            @assignments.push(assigned_parts)
            
        end
    end

    def edit
        @assignment_parts = Hash.new
        @assignment = Relationship.find(params[:id])
        Rails.logger.debug(@assignment[:keys])
        Rails.logger.debug(@assignment[:endusers])
        Rails.logger.debug(@assignment[:purchasers])
        Rails.logger.debug(@assignment[:purchaseorders])

        @assignment_parts["purchasers"] = @assignment[:purchasers].nil? ? nil :  Purchaser.find(@assignment[:purchasers])
        @assignment_parts["endusers"] = @assignment[:endusers].nil? ? nil :  EndUser.find(@assignment[:endusers])
        @assignment_parts["purchaseorders"] = @assignment[:purchaseorders].nil? ? nil : PurchaseOrder.find(@assignment[:purchaseorders])
        @assignment_parts["keys"] = @assignment[:keys].nil? ? nil : Key.find(@assignment[:keys])

		@categories = Hash.new
        @categories['keys'] = Key
        @categories['endusers'] = EndUser
        @categories['purchasers'] = Purchaser
        @categories['purchaseorders'] = PurchaseOrder

    end

    def update
        entry = Relationship.find(params[:id])
        entry.update_attributes(assignment_parameters)

        redirect_to "/manage"
    end

    def delete
        Relationship.delete(params[:id])

        redirect_to "/assign/manage"
    end

    private
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

    def assignment_parameters
        params.permit(:purchase_orders, :purchasers, :endusers, :keys)
    end
end
