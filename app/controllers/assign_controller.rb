class AssignController < ApplicationController
    # Authorizes User based on roles defined in app/models/ability.rb
    authorize_resource Key
    authorize_resource EndUser
    authorize_resource Purchaser 
    authorize_resource PurchaseOrder
    authorize_resource Relationship

    # Execute preliminary function before the following actions
	before_action :set_variables, only: [:create, :new, :search]
    before_action :set_hash, only: [:index, :edit]
    
    # Renders the initial page when assign is triggered
    # GET request
    #
    # Associated view - assign/index.html.erb
	def index
        # Reset the session enduser
        session[:enduser] = '0'
	end
    
    # Renders the a new form for any class
    # AJAX GET request
    #
    # Params:
    #   type - element to search for (PO, Purchaser, End User, Key Code)
    #
    # Associated "view" - assign/new.js.erb
    def new
        @entry = @class.new
        @name = @class.name.underscore.humanize.split.map(&:capitalize).join(' ')
    end

    # Creates the new element and renders it back to the screen
    # AJAX POST request
    #
    # Params
    #   type - element to create (PO, Purchaser, End User, Key Code)
    #
    # Associated "view" - assign/create.js.erb
    def create
        create_entry
    end
    
    # Creates a search form for the elements
    # AJAX GET request
    #
    # Params
    #   type - element to create (PO, Purchaser, End User, Key Code)
    #
    # Associated "view" - assign/search.js.erb
    def search
        @category = params[:type]
        @name = @class.name.underscore.humanize.split.map(&:capitalize).join(' ')
        
        # Search for correct item
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
            # if the map is active, render that instead of search form
            @mapActive = session[:enduser] != '0'

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
    
    # Redrafts map keys based on distance from center
    # AJAX POST request
    #
    # Params:
    #   red - size of the red circle
    #   yellow - size of the yellow circle
    #
    # Associated "view" - assign/update_map.js.erb
    def update_map
        @class = Key
        @css_class = "keys"
        @enduser = EndUser.find(session[:enduser])
        
        # Verify the parameters and collect the keys
        gather_map_border_paramters()
        gather_group_end_users_and_keys()
    end
    
    # Return search result
    # AJAX POST request
    #
    # Params:
    #   search_type - element to search for (PO, Purchaser, End User, Key Code)
    #
    # Associated view: assign/result.js.erb
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
    
    # Create the assignment and confirm with user
    # POST request
    #
    # Params:
    #   key - id for Key
    #   endusers - id for End User
    #   purchasers - id for Purchaser
    #   purchaseorders - id for purchaseorders
    #
    # Associated view - assign/assignment.html.erb
    def assignment
        # Create assignment
        Relationship.create(assignment_parameters)
        
        # Get human readable assignment values
        @assignment_parts = assign_parts(params)
    end

    # Get edit page for assignments
    # GET request
    #
    # Params:
    #   id - uniqued identifier of assignemtn to edit
    #
    # Associated view - assign/edit.html.erb
    def edit
        @assignment_parts = Hash.new
        # Retrieve assignment
        @assignment = Relationship.find(params[:id])

        # Retrieve each part of assignment (if it exists)
        @assignment_parts["purchasers"] = @assignment[:purchasers].nil? ? nil :  Purchaser.find(@assignment[:purchasers])
        @assignment_parts["endusers"] = @assignment[:endusers].nil? ? nil :  EndUser.find(@assignment[:endusers])
        @assignment_parts["purchaseorders"] = @assignment[:purchaseorders].nil? ? nil : PurchaseOrder.find(@assignment[:purchaseorders])
        @assignment_parts["keys"] = @assignment[:keys].nil? ? nil : Key.find(@assignment[:keys])
    end
    
    # Update assignment entry
    # POST request
    #
    # Params:
    #   id - unique identifier of assignment to update
    #
    # Redirects to view/manage/index.html.erb
    def update
        # Find the assignment and update it
        entry = Relationship.find(params[:id])
        entry.update_attributes(assignment_parameters)
        
        @active="assignments"
        redirect_to "/manage"
    end
    
    # Delete assignment entry
    # DELETE request
    #
    # Params:
    #   id - unique identifier of assignment to delete
    #
    # Redirects to view/manage/index.html.erb
    def delete
        # Delete the assignment
        Relationship.delete(params[:id])

        @active="assignments"
        redirect_to "/manage"
    end
    
    # Updates the enduser whenever it is clicked. It should only update to a value if the end user is part of a group.
    # AJAX POST request
    #
    # Params:
    #   enduser - id of enduser to update the sesion with
    def session_enduser
        session[:enduser] = params[:enduser]

        respond_to do |format|
            format.json { head :ok }
        end
    end

    private
    # Sets up global variables used by index and edit
    def set_hash
        # Create a new hash for the renderd boxes
		@categories = {
            'purchasers' => {
                "class": Purchaser,
                "name": 'Purchaser'
            },
            'endusers' => {
                "class": EndUser,
                "name":'End User'
            },
            'purchaseorders' => {
                "class": PurchaseOrder,
                "name": 'Purchase Order'
            },
            'keys' => {
                "class": Key,
                "name": 'Key'
            }
        }
    end
    
    # Ensures that circle parameters are valid and secure. Sets global variables to the values of
    #   yellow and red
    def gather_map_border_paramters
        if not params.key?("red")
            params[:red] = 25
            params[:yellow] = 50
        end
        @red = params[:red]
        @yellow = params[:yellow]
    end

    # Collects end users and keys and groups them based off of distance from the center
    def gather_group_end_users_and_keys
        # Group associated with center enduser
        end_user_group = EndUser.where(group_name: @enduser[:group_name])

        # Sort all end users by distance 
        @endusers_red = end_user_group.within(@red, :origin => @enduser[:address]);
        @endusers_yellow = end_user_group.in_range(@red..@yellow, :origin => @enduser[:address]);
        @endusers_green = end_user_group.beyond(@yellow, :origin => @enduser[:address]);
        
        # Remove @enduser
        @endusers_red = @endusers_red.to_a - [@enduser] 
        @endusers_yellow = @endusers_yellow.to_a - [@enduser]
        @endusers_green = @endusers_green.to_a - [@enduser]	
        
        # Gather keys assigned to these endusers
        @red_keys = get_assigned_keys(@endusers_red)
        @yellow_keys = get_assigned_keys(@endusers_yellow)
        @green_keys = get_assigned_keys(@endusers_green)
    end
    
    # Gather all keys assigned to the endusers specified
    #
    # Params:
    #   endusers - list of endusers to find keys from
    #
    # Returns:
    #   list of keys
    def get_assigned_keys(endusers)
        keys = Array.new
        endusers.each do |enduser|
            relationships = Relationship.where("endusers like?", "%#{enduser[:id]}")
            relationships.each do |relationship|
                unless relationship[:keys].blank?
                    key = Key.find(relationship[:keys])
                    key = key.as_json
                    key["enduser"] = enduser[:id]
                    keys.push(key)
                end
            end
        end

        return keys
    end
end
