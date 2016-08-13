class KeycodesController < ApplicationController
    def index
    end

    def show
        Rails.logger.debug(params)

        end_user_params = Hash.new
        key_codes_params = Hash.new
        purchase_orders_params = Hash.new
        purchases_params = Hash.new

        @end_users_list = Array.new
        @key_codes_list = Array.new
        @purchase_orders_list = Array.new
        @purchasers_list = Array.new

        params.each do |key, val|
            table = key.split('--')[0]
            column = key.split('--')[1]
            case table
            when "End User"
                case column
                when "Name"
                    @end_users_list += EndUser.where("name like ?", "%#{val}%")
                when "Address"
                    @end_users_list += EndUser.where("address like ?", "%#{val}%")
                when "Email"
                    @end_users_list += EndUser.where("email like ?", "%#{val}%")
                when "Department"
                    @end_users_list += EndUser.where("department like ?", "%#{val}%")
                when "Store Number"
                    @end_users_list += EndUser.where("store_number like ?", "%#{val}%")
                when "Phone"
                    @end_users_list += EndUser.where("phone like ?", "%#{val}%")
                else
                    Rails.logger.debug("** ERROR -- Did not match any End User Fields")
                    Rails.logger.debug(key)
                    Rails.logger.debug(val)
                end
            when "Key Codes"
                case column
                when "Key Code"
                    @key_codes_list += Key.where("key like ?", "%#{val}%")
                when "Master Key"
                    @key_codes_list += Key.where("master_key like ?", "%#{val}%")
                when "Control Key"
                    @key_codes_list += Key.where("control_key like ?", "%#{val}%")
                when "Stamp Code"
                    @key_codes_list += Key.where("stamp_code like ?", "%#{val}%")
                else
                    Rails.logger.debug("** ERROR -- Did not match any Key Code Fields")
                    Rails.logger.debug(key)
                    Rails.logger.debug(val)
                end
            when "Purchase Orders"
                case column
                when "S.O. Number"
                    @purchase_orders_list += PurchaseOrder.where("so_number like ?", "%#{val}%")
                when "P.O. Number"
                    @purchase_orders_list += PurchaseOrder.where("master_key like ?", "%#{val}%")
                when "Date Ordered"
                    @purchase_orders_list += PurchaseOrder.where("date_order like ?", "%#{val}%")
                else
                    Rails.logger.debug("** ERROR -- Did not match any Purchase ORder Fields")
                    Rails.logger.debug(key)
                    Rails.logger.debug(val)
                end
            when "Purchasers"
                case column
                when "Name"
                    @purchasers_list += Purchaser.where("name like ?", "%#{val}%")
                when "Address"
                    @purchasers_list += Purchaser.where("address like ?", "%#{val}%")
                when "Email"
                    @purchasers_list += Purchaser.where("email like ?", "%#{val}%")
                when "Phone"
                    @purchasers_list += Purchaser.where("phone like ?", "%#{val}%")
                when "Fax"
                    @purchasers_list += Purchaser.where("fax like ?", "%#{val}%")
                else
                    Rails.logger.debug("** ERROR -- Did not match any Purchase Fields")
                    Rails.logger.debug(key)
                    Rails.logger.debug(val)
                end
            else
                Rails.logger.debug ("SOMETHING WENT WRONG ==> " + key)
            end
        end
        Rails.logger.debug("** PARAMETERS **")
        Rails.logger.debug(@end_users_list)
        Rails.logger.debug(@key_codes_list)
        Rails.logger.debug(@purchase_orders_list)
        Rails.logger.debug(@purchases_list)

        @end_users_list = @end_users_list.uniq
        @key_codes_list = @key_codes_list.uniq
        @purchase_orders_list = @purchase_orders_list.uniq
        @purchasers_list = @purchasers_list.uniq

    end
end
