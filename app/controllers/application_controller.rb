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
	if address_attributes[:custom_address].empty?
		address += address_attributes[:line1].to_s + " " + address_attributes[:line2].to_s + "\n"
		address += address_attributes[:city].to_s + " " + address_attributes[:state].to_s + " "
		address += address_attributes[:zip]
	else
		address = address_attributes[:custom_attributes]
	end
	return address
  end
end
