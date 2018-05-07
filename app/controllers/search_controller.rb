class SearchController < ApplicationController
	before_action :set_arrays
	after_action :uniq_arrays

	def info
		case params[:category]
		when "enduser"
			@enduser = EndUser.find(params[:id])
		when "key"
			@key = Key.find(params[:id])
		when "purchaseorder"
			@purchaseorder = PurchaseOrder.find(params[:id])
		when "purchaser"
			@purchaser = Purchaser.find(params[:id])
		when "assignment"
			@assignment = Relationship.find(params[:id])
		end


		@info_view = "/shared/info/" + params[:category] + "info"
	end

    def index
        @purchase_order_search = PurchaseOrder.search
		@purchase_orders_list = @purchase_order_search.result

		@keycodes_search = Key.search
		@keycodes_list = @keycodes_search.result

		@end_users_search = EndUser.search
		@end_users_list = @end_users_search.result

		@purchasers_search = Purchaser.search
		@purchasers_list = @purchasers_search.result

		@assignments_search = Relationship.search
		@assignments_list = @assignments_search.result
    end

	def items 
        case params[:search_type]
        when "purchase_order_search"
            @class = PurchaseOrder
            @css_class = "purchaseorders"
            @name = "Purchase Orders"
        when "keycodes_search"
            @class = Key
            @css_class = "keycodes"
            @name = "Key Codes"
        when "end_user_search"
            @class = EndUser
            @css_class = "endusers"
            @name = "End Users"
        when "purchaser_search"
            @class = Purchaser
            @css_class = "purchasers"
            @name = "Purchaser"
        when "assignment_search"
            @class = Relationship
            @css_class = "assignments"
            @name = "Assignments"
        end
        
        @search = @class.search(params[:q])
        @list = @search.result
        @search.build_condition if @search.conditions.empty?
        @search.build_sort if @search.sorts.empty?

        respond_to do |format|
            format.js
        end
    end

	def export
		@class = ""
		@list = {}
		case params[:search_type]
		when "purchaser_search"
			@class = Purchaser
			search = Purchaser.search(params[:purchaser_search])
			@list = search.result
		when "end_user_search"
			@class = EndUser
			search = EndUser.search(params[:end_user_search])
			@list = search.result
		when "purchase_order_search"
			@class = PurchaseOrder
			search = PurchaseOrder.search(params[:purchase_order_search])
			@list = search.result
		when "keycodes_search"
			@class = Key
			search = Key.search(params[:keycodes_search])
			@list = search.result
		when "assignments_search"
			@class = Relationship
			search = Relationship.search(params[:assignments_search])
			@list = search.result
		end

		respond_to do |format|
			format.csv { send_data @list.to_csv }
		end
	end

    def show
		@end_users_list = EndUser.search(params[:q]).result
		@purchasers_list = Purchaser.search(params[:q]).result
    end
	
	def render_items
	end
	def get_purchasers
		params.each do |key, val|
            column = key.split('--')[1]
			@purchasers_list += purchaser_check(column, val)
		end	
        @purchasers_list = @purchasers_list.uniq.compact

		respond_to do |format|
			format.js
		end
	end

	def get_endusers
		params.each do |key, val|
            column = key.split('--')[1]
			@end_users_list += enduser_check(column, val)
		end	

		respond_to do |format|
			format.js
		end
	end

	def get_keys
		params.each do |key, val|
			column = key.split('--')[1]
			@key_codes_list += keycodes_check(column, val)
		end
		@key_codes_list = @key_codes_list.uniq.compact
		respond_to do |format|
			format.js
		end
	end

	def get_keys_map
	end

	private
	def purchaser_check(key, val)
		case key
		when "Name"
			return Purchaser.where("name like ?", "%#{val}%")
		when "Phone"
			return Purchaser.where("phone like ?", "%#{val}%")
		when "Fax"
			return Purchaser.where("fax like ?", "%#{val}%")
		when "Group"
			return Purchaser.where("group like ?", "%#{val}%")
		else
			print_debug(key, val, "Purchaser")
			return []
		end
	end
	
	def enduser_check(key, val)
		case key 
		when "Name"
			return EndUser.where("name like ?", "%#{val}%")
		when "Address"
			return EndUser.where("address like ?", "%#{val}%")
		when "Department"
			return EndUser.where("department like ?", "%#{val}%")
		when "Store Number"
			return EndUser.where("store_number like ?", "%#{val}%")
		when "Phone"
			return EndUser.where("phone like ?", "%#{val}%")
		when "Group"
			return EndUser.where("group_name like ?", "%#{val}%")
		else
			print_debug(key, val, "End User")
			return []
		end
	end

	def keycodes_check(key, val)
		case key 
		when "Key Code"
			return Key.where("`keyway` like ?", "%#{val}%")
		when "Master Key"
			return Key.where("master_key like ?", "%#{val}%")
		when "Control Key"
			return Key.where("control_key like ?", "%#{val}%")
		when "Stamp Code"
			return Key.where("stamp_code like ?", "%#{val}%")
		else
			print_debug(key, val, "Key")
			return []
		end
	end


	def set_arrays
        @end_users_list = Array.new
        @key_codes_list = Array.new
        @purchase_orders_list = Array.new
        @purchasers_list = Array.new
        @assignments_list = Array.new

		session[:purchase_order_search] = {}
		session[:purchaser_search] = {}
		session[:end_user_search] = {}
		session[:keycodes_search] = {}
		session[:assignments_search] = {}
	end

	def uniq_arrays
        @end_users_list = @end_users_list.uniq.compact
        @key_codes_list = @key_codes_list.uniq.compact
        @purchase_orders_list = @purchase_orders_list.uniq.compact
        @purchasers_list = @purchasers_list.uniq.compact
        @assignments_list = @purchasers_list.uniq.compact
	end

	def print_debug(key, val, table)
		Rails.logger.debug("** ERROR -- Did not match any " + table + " fields")
		Rails.logger.debug(key.to_s + " ---- " + val.to_s)
	end
end
