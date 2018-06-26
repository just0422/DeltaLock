class ManageController < ApplicationController
    authorize_resource Key
    authorize_resource EndUser
    authorize_resource Purchaser 
    authorize_resource PurchaseOrder
    authorize_resource Relationship
    authorize_resource User
    before_action :set_variables, only: [:upload, :download]

    def index
        @file_options = [
            ["Keys", "keys"],
            ["End Users", "endusers"],
            ["Purchasers", "purchasers"],
            ["Purchase Orders", "purchaseorders"],
            ["Assignments", "assignments"]
        ]

        @assignments = Array.new
        list = Relationship.all

        list.each do |assignment|
            assigned_parts = Hash.new
            assigned_parts[:data] = assign_parts(assignment)
            assigned_parts[:id] = assignment[:id]
            @assignments.push(assigned_parts)
        end
        
        @users = User.all
    end

    def upload
        #check form requirements satisfied
        if !params.key?("file")
            @message = "Please select a file"
            respond_to do |format|
                format.js { render layout: "error" }
            end
        elsif !params.key?("type")
            @message = "Please select a type"
            respond_to do |format|
                format.js { render layout: "error" }
            end
        else
            @result = @class.import(params[:file])
        end
    end

    def download
        if params[:template] == "0"
            search = @class.search
            @result = search.result
        else
            @result = @class.column_names
        end

		respond_to do |format|
			format.csv { send_data @result.to_csv }
		end
    end
end
