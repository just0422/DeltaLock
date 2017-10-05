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
end
