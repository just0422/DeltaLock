class EntryController < ApplicationController
    authorize_resource Key
    authorize_resource EndUser
    authorize_resource Purchaser 
    authorize_resource PurchaseOrder
    authorize_resource Relationship
	before_action :set_variables, only: [:show, :edit, :update, :delete]

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
        authorize! :create, :all
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

        redirect_to show_entry_path(params[:type], @entry[:id])
    end

	def edit 
        authorize! :update, :all
        @entry = @class.find(params[:id])
    end

	def update
        authorize! :update, :all
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

    def delete
        authorize! :destroy, :all
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
        params[:bitting_driver] = remap_bits(params[:bitting_driver])
        params[:bitting_master] = remap_bits(params[:bitting_master])
        params[:bitting_control] = remap_bits(params[:bitting_control])
        params[:bitting_bottom] = remap_bits(params[:bitting_bottom])
		params.permit(:keyway, :master_key, :control_key, :operating_key, :bitting, :system_name, :comments, :keycode_stamp, :reference_code, :bitting_driver, :bitting_master, :bitting_control, :bitting_bottom)
	end

    def remap_bits(bitting)
        bitting.sort.map{|k,v| "#{v}"}.join('/')
    end
end
