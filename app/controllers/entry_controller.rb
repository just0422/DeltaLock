class EntryController < ApplicationController
	before_action :set_variables, only: [:show, :edit, :update]

    def index
    end

	def show
        @entry = @class.find(params[:id])

		case params[:type]
		when "key"
			@associations = get_associated_items("key", params[:id])
		when "enduser"
			@associations = get_associated_items("enduser", params[:id])
		when "purchaser"
			@associations = get_associated_items("purchaser", params[:id])
		when "purchaseorder"
			@associations = get_associated_items("purchaseorder", params[:id])
		end

		@column_names = {
			"key" => "Key",
			"enduser" => "End User",
			"purchaser" => "Purchaser",
			"purchaseorder" => "Purchase Order"
		}
	end

	def edit 
        @entry = @class.find(params[:id])
    end

	def update
        @entry = @class.find(params[:id])

		case params[:type]
		when "key"
			@entry.update_attributes(key_parameters)
		when "enduser"
			@entry.update_attributes(enduser_parameters)
		when "purchaser"
			@entry.update_attributes(purchaser_parameters)
		when "purchaseorder"
			@entry.update_attributes(purchaseorder_parameters)
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
	def get_associated_items(type, id)
		associations = Array.new
		
		type += "s"
		list = Relationship.where({ type.to_s => 1 })

		list.each do |assignment|
			association = Hash.new

			key_entry = assignment[:keys].blank? ? nil : Key.find(assignment[:keys])
			key = {
				"name" => key_entry ? key_entry[:system_name] : "",
				"id" => key_entry ? assignment[:keys] : "",
			}
			association["key"] = key

			enduser_entry = assignment[:endusers].blank? ? nil : EndUser.find(assignment[:endusers])
			enduser = { 
				"name" => enduser_entry ? enduser_entry[:name] : "",
				"id" => enduser_entry ? assignment[:endusers] : ""
			}
			association["enduser"] = enduser

			purchaser_entry = assignment[:purchasers].blank? ? nil : Purchaser.find(assignment[:purchasers])
			purchaser = { 
				"name" => purchaser_entry ? purchaser_entry[:name] : "",
				"id" => purchaser_entry ? assignment[:purchasers] : ""
			}
			association["purchaser"] = purchaser

			purchaseorder_entry = assignment[:purchaseorders].blank? ? nil : PurchaseOrder.find(assignment[:purchaseorders])
			purchaseorder = { 
				"name" => purchaseorder_entry ? purchaseorder_entry[:so_number] : "",
				"id" => purchaseorder_entry ? assignment[:purchaseorders] : ""
			}
			association["purchaseorder"] = purchaseorder

			associations.push(association)
		end

		return associations
	end

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
