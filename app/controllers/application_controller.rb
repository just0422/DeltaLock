class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user 
  helper_method :require_user
  helper_method :require_admin
  helper_method :build_address_string

  def current_user 
	@current_user ||= User.find(session[:user_id]) if session[:user_id] 
  end

  def require_user 
	redirect_to '/login' unless current_user 
  end

  def require_admin
	redirect_to '/' unless current_user.admin? 
  end

  def build_address_string(address_attributes)
	address = ""
	if address_attributes == nil
		return address
	end
	if address_attributes[:custom_address] == nil or address_attributes[:custom_address].empty?
		address += address_attributes[:line1] + " " if address_attributes[:line1] != nil
		address += address_attributes[:line2] + " " if address_attributes[:line2] != nil
		address += address_attributes[:city] + ", " if address_attributes[:city] != nil
		address += address_attributes[:state] + " " if address_attributes[:state] != nil
		address += address_attributes[:zip] if address_attributes[:zip] != nil
	else
		address = address_attributes[:custom_address]
	end
	return address
  end


    def assign_parts(parts)
        assignment_parts = Hash.new

		key_entry = parts[:keys].blank? ? nil : Key.find(parts[:keys])
        assignment_parts["keys"] = {
            "title" => "Key",
            "name" => key_entry ? key_entry[:system_name] : "",
            "id" => key_entry ? parts[:keys] : ""
        }

		enduser_entry = parts[:endusers].blank? ? nil : EndUser.find(parts[:endusers])
        assignment_parts["endusers"] = {
            "title" => "End User",
            "name" => enduser_entry ? enduser_entry[:name] : "",
            "id" => enduser_entry ? parts[:endusers] : ""
        }

		purchaser_entry = parts[:purchasers].blank? ? nil : Purchaser.find(parts[:purchasers])
        assignment_parts["purchasers"] = {
            "title" => "Purchaser",
            "name" => purchaser_entry ? purchaser_entry[:name] : "",
            "id" => purchaser_entry ? parts[:purchasers] : ""
        }

		purchaseorder_entry = parts[:purchaseorders].blank? ? nil : PurchaseOrder.find(parts[:purchaseorders])
        assignment_parts["purchaseorders"] = {
            "title" => "Purchase Order",
            "name" => purchaseorder_entry ? purchaseorder_entry[:so_number] : "",
            "id" => purchaseorder_entry ? parts[:purchaseorders] : ""
        }

        return assignment_parts
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
end
