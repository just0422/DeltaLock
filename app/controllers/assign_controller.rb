class AssignController < ApplicationController
    authorize_resource Key
    authorize_resource EndUser
    authorize_resource Purchaser 
    authorize_resource PurchaseOrder
    authorize_resource Relationship
	before_action :set_variables, only: [:create, :new, :search]

	def index
		@categories = [ Purchaser, EndUser, PurchaseOrder, Key ]

		@categories = Hash.new
        @categories['purchasers'] = Purchaser
        @categories['endusers'] = EndUser
        @categories['purchaseorders'] = PurchaseOrder
        @categories['keys'] = Key

        session[:enduser] = 0
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
            @mapActive = session[:enduser] != 0

            if @mapActive 
                @enduser = EndUser.find(session[:enduser])
                
                gather_map_border_paramters()
                gather_group_end_users_and_keys()
            else
                @categoryName = "Key"
                @categorySearch = Key.search
            end
        end
    end

    def update_map
        @class = Key
        @css_class = "keys"
        @enduser = EndUser.find(session[:enduser])
        
        gather_map_border_paramters()
        gather_group_end_users_and_keys()

        respond_to do |format|
            format.js
        end
    end

    def result
        case params[:search_type]
        when "purchaseorders"
            @class = PurchaseOrder
            @name = "Purchase Orders"
        when "keys"
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

        @assignment_parts = assign_parts(params)
    end

    def manage
        @assignments = Array.new
        list = Relationship.all

        list.each do |assignment|
            assigned_parts = Hash.new
            assigned_parts[:data] = assign_parts(assignment)
            assigned_parts[:id] = assignment[:id]
            @assignments.push(assigned_parts)
        end
    end

    def edit
        @assignment_parts = Hash.new
        @assignment = Relationship.find(params[:id])

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

        redirect_to "/manage"
    end

    def session_enduser
        session[:enduser] = params[:enduser]

        respond_to do |format|
            format.json { head :ok }
        end
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
        params.permit(:purchaseorders, :purchasers, :endusers, :keys)
    end

    def gather_map_border_paramters
        if not params.key?("red")
            params[:red] = 25
            params[:yellow] = 50
        end
        @red = params[:red]
        @yellow = params[:yellow]
    end

    def gather_group_end_users_and_keys
        end_user_group = EndUser.where(group_name: @enduser[:group_name])
        @endusers_red = end_user_group.within(@red, :origin => @enduser[:address]);
        @endusers_yellow = end_user_group.in_range(@red..@yellow, :origin => @enduser[:address]);
        @endusers_green = end_user_group.beyond(@yellow, :origin => @enduser[:address]);

        @endusers_red = @endusers_red.to_a - [@enduser] 
        @endusers_yellow = @endusers_yellow.to_a - [@enduser]
        @endusers_green = @endusers_green.to_a - [@enduser]	
        
        @red_keys = get_associated_keys(@endusers_red)
        @yellow_keys = get_associated_keys(@endusers_yellow)
        @green_keys = get_associated_keys(@endusers_green)
    end

    def get_associated_keys(endusers)
        keycodes = Array.new
        endusers.each do |enduser|
            relationships = Relationship.where("endusers like?", "%#{enduser[:id]}")
            relationships.each do |relationship|
                unless relationship[:keys].blank?
                    key = Key.find(relationship[:keys])
                    key = key.as_json
                    key["enduser"] = enduser[:id]
                    keycodes.push(key)
                end
            end
        end

        return keycodes
    end
end
