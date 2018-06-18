class EntryController < ApplicationController
	before_action :set_variables, only: [:show, :edit, :update, :delete]

    def index
    end

	def show
        @entry = @class.find(params[:id])

		@associations = get_associated_items(params[:type], params[:id])

		@column_names = {
			"keys" => "Key",
			"endusers" => "End User",
			"purchasers" => "Purchaser",
			"purchaseorders" => "Purchase Order"
		}
	end

	def edit 
        @entry = @class.find(params[:id])
    end

	def update
        @entry = @class.find(params[:id])

		case params[:type]
		when "keys"
			@entry.update_attributes(key_parameters)
		when "endusers"
            geo = EndUser.geocode(params[:address])
            @entry[:lat] = geo.lat
            @entry[:lng] = geo.lng

			@entry.update_attributes(enduser_parameters)

		when "purchasers"
			@entry.update_attributes(purchaser_parameters)
		when "purchaseorders"
			@entry.update_attributes(purchaseorder_parameters)
		end

        @entry = @class.find(params[:id])
	end

    def new
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

        redirect_to "/show/" + params[:type] + "/" + @entry[:id].to_s
    end

    def delete
        ignore_columns = ["id", "created_at", "updated_at"]
		list = Relationship.where({ @type.to_s => @id })

		list.each do |assignment|
            assignment[type] = nil

            count = 0
            Relationship.column_names.each do |column|
                if assignment[column] != nil and not ignore_columns.include?(column)
                    count += 1
                end
            end
            
            if count <= 1
                assignment.destroy
            else
                assignment.save
            end
        end

        @class.destroy(@id)
    end

	private
	def get_associated_items(type, id)
		associations = Array.new
		
		list = Relationship.where({ type.to_s => id })

		list.each do |assignment|
            association = assign_parts(assignment)

			associations.push(association)
		end

		return associations
	end

	def set_variables
		case params[:type]
		when "keys"
			@class = Key
		when "endusers"
			@class = EndUser
		when "purchasers"
			@class = Purchaser
		when "purchaseorders"
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
