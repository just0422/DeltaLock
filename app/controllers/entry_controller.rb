class EntryController < ApplicationController
    # Authorizes User based on roles defined in app/models/ability.rb
    authorize_resource Key
    authorize_resource EndUser
    authorize_resource Purchaser 
    authorize_resource PurchaseOrder
    authorize_resource Relationship

    # Execute preliminary function before the following actions
	before_action :set_variables, only: [:show, :edit, :update, :delete]
    
    # Shows the entry page for any element specified in the url
    # GET request
    #
    # Params:
    #   type - element to search for (PO, Purchaser, End User, Key Code)
    #   id - unique identfier for the database to return
    #
    # Associated View: entry/show.html.erb
	def show
        # Find the element and assign it to a global variable
        @entry = @class.find(params[:id]) 
    
        # Get all assigned items
		@assignments = get_assignments(params[:type], params[:id])
        
        # Setup column names for assignments table
		@column_names = {
			"keys" => "Key",
			"endusers" => "End User",
			"purchasers" => "Purchaser",
			"purchaseorders" => "Purchase Order"
		}
	end
    
    # Generates the form for a new entry
    # GET request
    #
    # Associated View: entry/new.html.erb
    def new
        # Necessary data to render a new form for each type
		@columns = {
			"keys" => {
                "name" => "Key",
                "class" => Key,
                "entry" => Key.new
            },
			"endusers" => {
                "name" => "End User",
                "class" => EndUser,
                "entry" => EndUser.new
            },
			"purchasers" => {
                "name" => "Purchaser",
                "class" => Purchaser,
                "entry" => Purchaser.new
            },
			"purchaseorders" => {
                "name" => "Purchase Order",
                "class" => PurchaseOrder,
                "entry" => PurchaseOrder.new
            }
		}
    end
    
    # Creates the new entry
    # POST request
    #
    # Params:
    #   type - element to create (PO, Purchaser, End User, Key Code)
    #
    # Redirects to show_entry_path -- /entry/show/:type/:id
    def create
        create_entry
        
        # Redirect to entry view to show the new element
        redirect_to show_entry_path(params[:type], @entry[:id])
    end
    
    # Generates edit form for an entry
    # AJAX GET request
    #
    # Params:
    #   type - element to edit (PO, Purchaser, End User, Key Code)
    #   id - unique identfier for the database fetch
    #
    # Associated "view" - entry/edit.js.erb
	def edit 
        #Find the entry
        @entry = @class.find(params[:id])
    end
    
    # Updates the entry being edited
    # AJAX POST request
    #
    # Params:
    #   type - element to update (PO, Purchaser, End User, Key Code)
    #   id - unique identfier for the database to update 
    #
    # Associated "view" - entry/update.js.erb
	def update
        # Retrieve entry before update
        @entry = @class.find(params[:id])
        
        # Update correct entry base on type
		case params[:type]
		when "keys"
			@entry.update_attributes(key_parameters)
		when "endusers"
            # Geocode address (for mapping feature)
            geo = EndUser.geocode(params[:address])
            @entry[:lat] = geo.lat
            @entry[:lng] = geo.lng

			@entry.update_attributes(enduser_parameters)
		when "purchasers"
			@entry.update_attributes(purchaser_parameters)
		when "purchaseorders"
			@entry.update_attributes(purchaseorder_parameters)
		end

        # Retrieve newly saved entry
        @entry = @class.find(params[:id])
	end
    
    # Deletes a specified entry
    # DELETE request
    #
    # Params:
    #   type - element to delete (PO, Purchaser, End User, Key Code)
    #   id - unique identfier for the database to delete
    #
    # Associated View: entry/delete.html.erb
    def delete
        ignore_columns = ["id", "created_at", "updated_at"]
        # Find all assignments associated with this element
		list = Relationship.where({ @type.to_s => @id })
    
        # For each assignment
		list.each do |assignment|
            # Remove this element from the assigment
            assignment[type] = nil
            
            # Count how many elements are left
            count = 0
            Relationship.column_names.each do |column|
                if assignment[column] != nil and not ignore_columns.include?(column)
                    count += 1
                end
            end
            
            # If only one element is left, destroy the assignment
            if count <= 1
                assignment.destroy
            # Otherwise, save
            else
                assignment.save
            end
        end
        
        # Destroy the desired element
        @class.destroy(@id)
    end

	private
    # Gets all the assigments that 'id' is a part of
    #
    # Params:
    #   type - assignments column to query (PO, Purchaser, End User, Key Code)
    #   id - unique identifier belonging to an assignment type
    #
    # Returns:
    #   A list of assignments where each 'type' field is a human readable element
    #       instead of an arbitrary 'id'
	def get_assignments(type, id)
		assignments = Array.new
		
        # Gather all assignments with this 'id' in the 'type' column
		list = Relationship.where({ type.to_s => id })

        # In each assignment
		list.each do |relationship|
            # Gather human readable parts
            assignment = assign_parts(relationship)
			assignments.push(assignment)
		end

		return assignments
	end
end
