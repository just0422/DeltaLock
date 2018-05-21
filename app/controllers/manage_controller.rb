class ManageController < ApplicationController
    def index
        @options = [
            ["Keys", "keys"],
            ["End Users", "endusers"],
            ["Purchasers", "purchasers"],
            ["Purchase Orders", "purchaseorders"],
            ["Assignments", "assignments"]
        ]
    end

    def upload
        #check form requirements satisfied
    end

    def download
    end

    def manage
    end
end
