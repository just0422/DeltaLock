class ShowController < ApplicationController
	before_action :set_variables, only: [:show, :edit, :update]
  def index
		
  end

	def show
		case params[:type]
		when "key"
			@associations = get_associated_items("key", params[:id])
		when "end_user"
			@associations = get_associated_items("end_user", params[:id])
		when "purchaser"
			@associations = get_associated_items("purchaser", params[:id])
		when "purchase_order"
			@associations = get_associated_items("purchase_order", params[:id])
		end
		@column_names = {
			"key" => "Key",
			"end_user" => "End User",
			"purchaser" => "Purchaser",
			"purchase_order" => "Purchase Order"
		}
	end

	def edit
	end

	def update
		Rails.logger.debug(params)
		case params[:type]
		when "key"
			@entry.update_attributes(key_parameters)
		when "end_user"
			@entry.update_attributes(enduser_parameters)
		when "purchaser"
			@entry.update_attributes(purchaser_parameters)
		when "purchase_order"
			@entry.update_attributes(purchase_order_parameters)
		end
	end

	private
	def get_associated_items(type, id)
		associations = Array.new
		
		type += "_id"
		list = Relationship.where({ type.to_s => 1 })

		list.each do |assignment|
			association = Hash.new

			key_entry = assignment[:key_id].blank? ? nil : Key.find(assignment[:key_id])
			key = {
				"name" => key_entry ? key_entry[:system_name] : "",
				"id" => key_entry ? assignment[:key_id] : "",
			}
			association["key"] = key

			end_user_entry = assignment[:end_user_id].blank? ? nil : EndUser.find(assignment[:end_user_id])
			end_user = { 
				"name" => end_user_entry ? end_user_entry[:name] : "",
				"id" => end_user_entry ? assignment[:end_user_id] : ""
			}
			association["end_user"] = end_user

			purchaser_entry = assignment[:purchaser_id].blank? ? nil : Purchaser.find(assignment[:purchaser_id])
			purchaser = { 
				"name" => purchaser_entry ? purchaser_entry[:name] : "",
				"id" => purchaser_entry ? assignment[:purchaser_id] : ""
			}
			association["purchaser"] = purchaser

			purchase_order_entry = assignment[:purchase_order_id].blank? ? nil : PurchaseOrder.find(assignment[:purchase_order_id])
			purchase_order = { 
				"name" => purchase_order_entry ? purchase_order_entry[:so_number] : "",
				"id" => purchase_order_entry ? assignment[:purchase_order_id] : ""
			}
			association["purchase_order"] = purchase_order

			associations.push(association)
		end

		return associations
	end

	def set_variables
		case params[:type]
		when "key"
			@entry = Key.find(params[:id])
			@class = Key
		when "end_user"
			@entry = EndUser.find(params[:id])
			@class = EndUser
		when "purchaser"
			@entry = Purchaser.find(params[:id])
			@class = Purchaser
		when "purchase_order"
			@entry = PurchaseOrder.find(params[:id])
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

	def purchase_order_parameters
		params.permit(:po_number, :date_order, :so_number)
	end

	def key_parameters
		params.permit(:keyway, :master_key, :control_key, :operating_key, :bitting, :system_name, :comments)
	end
end
