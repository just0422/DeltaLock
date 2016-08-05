class KeycodesController < ApplicationController
    def index
    end

    def show
        Rails.logger.debug("**********************************************")
        Rails.logger.debug("***************PARAMETERS*********************")
        Rails.logger.debug("**********************************************")
        Rails.logger.debug(params)

        end_user_params = Hash.new
        key_codes_params = Hash.new
        purchase_orders_params = Hash.new
        purchases_params = Hash.new

        params.each do |key, val|
            table = key.split('--')[0]
            column = key.split('--')[1]
            case table
            when "End User"
                case column
                when "Name"
                    end_user_params[:name] = val
                when "Address"
                    end_user_params[:address] = val
                when "Email"
                    end_user_params[:email] = val
                when "Department"
                    end_user_params[:department] = val
                when "Store Number"
                    end_user_params[:store_number] = val
                when "Phone"
                    end_user_params[:phone] = val
                else
                    Rails.logger.debug("DID NOT MATCH ANY PARAMETER")
                    Rails.logger.debug(key)
                    Rails.logger.debug(val)
                end
            else
                Rails.logger.debug ("SOMETHING WENT WRONG")
            end
        end
        Rails.logger.debug("PPPPPPPPPPPPPPPPPPPPAAAAAAAAAAAAAAARRRRRRRRRAAAAAAAAAMMMMMMMMSSSS")
        Rails.logger.debug(end_user_params)

        @end_users = EndUser.find_by(end_user_params)
    end
end
