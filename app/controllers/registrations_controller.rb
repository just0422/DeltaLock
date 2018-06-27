class RegistrationsController < Devise::RegistrationsController
    authorize_resource User
    respond_to :js
    
    # Creates a user with appropriate rol
    #
    # Params:
    #   user - hash of attributes to assign to user
    #   role - role to give the user
    #
    # Associated view: registrations/manage.js.erb
	def create
        # Slight modification of the devise create function
        build_resource(sign_up_params)
        resource.save
        resource.add_role params[:role]

        yield resource if block_given?
        if resource.persisted?
            if resource.active_for_authentication?
                set_flash_message! :notice, :signed_up
            else
                set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
                expire_data_after_sign_in!
            end
        else
            clean_up_passwords resource
            set_minimum_password_length
        end
        
        # Gather all users so table can be rendered
        @users = User.all
        render "manage"
    end
    
    # Retrieves user to be edited
    #
    # Params:
    #   id - unique identifier of user to update
    #
    # Associated "view": registrations/edit_users.js.erb
    def edit_users
        @user = User.find(params[:id])
        @role = @user.roles.first.name
    end
    
    # Updates user
    #
    # Params:
    #   id - unique identifier of user to be updated
    #
    # Associated view: registrations/manage.js.erb
    def update_users
        # Slighly modified version of devise update
		resource = User.find(params[:id])
        resource_updated = update_user(resource, update_params) && update_role(resource, params[:role])

        yield resource if block_given?
        if resource_updated
            if is_flashing_format?
                flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
                    :update_needs_confirmation : :updated
                set_flash_message :notice, flash_key
            end
        else
            clean_up_passwords resource
            set_minimum_password_length
        end
        
        # Gather all users so table can be rendered
        @users = User.all
		render "manage"
    end
    
    # Deletes a user
    #
    # Params:
    #   id - unique identifier of user to delete
    #
    # Associated view: registrations/manage.js.erb
	def destroy_users
        user = User.find(params[:id])
        
        # Delete user
        user.destroy

        # Sign out of any machines user is on
        Devise.sign_out_all_scopes ? sign_out : sign_out(:user)
        set_flash_message! :notice, :destroyed
        
        @users = User.all
        render "manage"
    end
    
    protected
    # Perorms update on a user
    #
    # Params:
    #   user - user to be updated
    #   params - filtered parameters
    #
    # Returns:
    #   Updated user
    def update_user(user, params)
        # Remove password if blank
        if params[:password].blank?
            params.delete(:password)
        end
        
        # Update user
        return user.update(params)
    end
    
    # Updates user role
    #
    # Params:
    #   user - user whose role is updated
    #   role - new role
    def update_role(user, role)
        # Remove any existing roles
        user.roles.each do |old_role|
            user.remove_role old_role.name
        end

        # Apply new role
        user.add_role role
        
        # Verify and return new role
        return user.has_role? role
    end
end

