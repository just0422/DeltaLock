class ApplicationController < ActionController::Base
    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    protect_from_forgery with: :exception

    before_action :configure_permitted_parameters, if: :devise_controller?
    rescue_from CanCan::AccessDenied do |exception|
        redirect_to new_user_session_url
    end

    helper_method :is_viewer
    helper_method :is_editor
    helper_method :is_admin

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
        when "assignments"
            @class = Relationship
		end
		@id = params[:id]
		@type = params[:type]
	end

    def is_viewer
        return (can? :read, Key) && 
               (can? :read, EndUser) && 
               (can? :read, Purchaser) && 
               (can? :read, PurchaseOrder) && 
               (can? :read, Relationship)
    end
    def is_editor
        return (can? :create, Key) && 
               (can? :create, EndUser) && 
               (can? :create, Purchaser) && 
               (can? :create, PurchaseOrder) && 
               (can? :create, Relationship)
    end
    def is_admin
        return (can? :manage, :all)
    end

    def readable_classes
        [Key, EndUser, Purchaser, PurchaseOrder, Relationship]
    end

    protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:signup, keys: [:email, :password, :first_name, :last_name])
        devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :current_password, :first_name, :last_name])
    end
end
