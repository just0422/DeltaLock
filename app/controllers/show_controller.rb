class ShowController < ApplicationController
  def index
		
  end

	def show
		case params[:type]
		when "key"
			@entry = Key.find(params[:id])
			@class = Key
			@associations = get_associated_items("key", params[:id])
		when "end_user"
			@entry = EndUser.find(params[:id])
			@class = EndUser
			@associations = get_associated_items("end_user", params[:id])
		when "purchaser"
			@entry = Purchaser.find(params[:id])
			@class = Purchaser
			@associations = get_associated_items("purchaser", params[:id])
		when "purchase_order"
			@entry = PurchaseOrder.find(params[:id])
			@class = PurchaseOrder
			@associations = get_associated_items("purchase_order", params[:id])
		end
		@id = params[:id]
		@type = params[:type]
		@column_names = {
			"key" => "Key",
			"end_user" => "End User",
			"purchaser" => "Purchaser",
			"purchase_order" => "Purchase Order"
		}
	end

	def edit

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
end
