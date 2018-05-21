class ManageController < ApplicationController
    before_action :set_variables, only: [:upload]

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
    end

    def manage
    end
end
