class ManageController < ApplicationController
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
    end

    def download
    end

    def manage
    end
end
