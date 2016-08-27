class KeycodesController < ApplicationController
	before_action :set_arrays
	after_action :uniq_arrays

	def index
    end


    def show
        params.each do |key, val|
            table = key.split('--')[0]
            column = key.split('--')[1]
            case table
            when "End User"
				@end_users_list += enduser_check(column, val)
				Rails.logger.debug(@end_users_list)
            when "Key Codes"
                case column
                when "Key Code"
                    @key_codes_list += Key.where("`key` like ?", "%#{val}%")
                when "Master Key"
                    @key_codes_list += Key.where("master_key like ?", "%#{val}%")
                when "Control Key"
                    @key_codes_list += Key.where("control_key like ?", "%#{val}%")
                when "Stamp Code"
                    @key_codes_list += Key.where("stamp_code like ?", "%#{val}%")
                else
					print_debug(key, val, "Key")
                end
            when "Purchase Orders"
                case column
                when "S.O. Number"
                    @purchase_orders_list += PurchaseOrder.where("so_number like ?", "%#{val}%")
                when "P.O. Number"
                    @purchase_orders_list += PurchaseOrder.where("po_number like ?", "%#{val}%")
                when "Date Ordered"
                    @purchase_orders_list += PurchaseOrder.where("date_order like ?", "%#{val}%")
                else
					print_debug(key, val, "Purchase Order")
                end
            when "Purchasers"
				@purchasers_list += purchaser_check(column, val)
            else
                Rails.logger.debug ("SOMETHING WENT WRONG ==> " + key)
            end
        end

    end
	
	
	def get_purchasers
		params.each do |key, val|
            column = key.split('--')[1]
			@purchasers_list += purchaser_check(column, val)
		end	
        @purchasers_list = @purchasers_list.uniq
		respond_to do |format|
			format.js
		end
	end

	def get_endusers
		params.each do |key, val|
            column = key.split('--')[1]
			@end_users_list += enduser_check(column, val)
		end	
		@end_users_list = @end_users_list.uniq
		respond_to do |format|
			format.js
		end
	end

	private
	def purchaser_check(key, val)
		case key
		when "Name"
			return Purchaser.where("name like ?", "%#{val}%")
		when "Address"
			return Purchaser.where("address like ?", "%#{val}%")
		when "Email"
			return Purchaser.where("email like ?", "%#{val}%")
		when "Phone"
			return Purchaser.where("phone like ?", "%#{val}%")
		when "Fax"
			return Purchaser.where("fax like ?", "%#{val}%")
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
		when "Email"
			return EndUser.where("email like ?", "%#{val}%")
		when "Department"
			return EndUser.where("department like ?", "%#{val}%")
		when "Store Number"
			return EndUser.where("store_number like ?", "%#{val}%")
		when "Phone"
			return EndUser.where("phone like ?", "%#{val}%")
		else
			print_debug(key, val, "End User")
			return []
		end
	end

	def set_arrays
        @end_users_list = Array.new
        @key_codes_list = Array.new
        @purchase_orders_list = Array.new
        @purchasers_list = Array.new
	end

	def uniq_arrays
        @end_users_list = @end_users_list.uniq.compact
        @key_codes_list = @key_codes_list.uniq.compact
        @purchase_orders_list = @purchase_orders_list.uniq.compact
        @purchasers_list = @purchasers_list.uniq.compact
	end

	def print_debug(key, val, table)
		Rails.logger.debug("** ERROR -- Did not match any " + table + " fields")
		Rails.logger.debug(key.to_s + " ---- " + val.to_s)
	end
end
