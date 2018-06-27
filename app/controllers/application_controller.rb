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

    protected
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

    def create_entry
        # Determine the type and create it
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

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:signup, keys: [:email, :password, :first_name, :last_name])
        devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :current_password, :first_name, :last_name])
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
    
    def sign_up_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
    end

    def update_params
        params.require(:user).permit(:email, :password, :first_name, :last_name)
    end

    # Allowed parameters for updating or creating and end user
    def assignment_parameters
        params.permit(:purchaseorders, :purchasers, :endusers, :keys)
    end
    
    private
    def remap_bits(bitting)
        bitting.sort.map{|k,v| "#{v}"}.join('/')
    end
end
