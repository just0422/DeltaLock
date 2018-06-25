class RegistrationsController < Devise::RegistrationsController
    respond_to :js

	def create
        authorize! :create, User
        build_resource(sign_up_params)
        resource.save

        user = User.find(resource.id)
        user.add_role params[:role]

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

        @users = User.all
        render "manage"
    end

    def edit_users
        authorize! :update, User
        @user = User.find(params[:id])
        @role = @user.roles.first.name
    end

    def update_users
        authorize! :update, User
		resource = User.find(params[:id])

        resource_updated = update_user(resource, update_params) && 
        update_role(resource, params[:role])
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

        @users = User.all
		render "manage"
    end

	def destroy_users
        authorize! :destroy, User
        user = User.find(params[:id])

        user.destroy
        Devise.sign_out_all_scopes ? sign_out : sign_out(:user)
        set_flash_message! :notice, :destroyed
        
        @users = User.all
        render "manage"
    end
    
    protected
    def sign_up_params
        params.require(:user).permit(:username, :email, :password, :first_name, :last_name)
    end

    def update_params
        params.require(:user).permit(:username, :email, :password, :first_name, :last_name)
    end

    def update_user(user, params)
        if params[:password].blank?
            params.delete(:password)
        end

        return user.update(params)
    end
    
    def update_role(user, role)
        user.roles.each do |old_role|
            user.remove_role old_role.name
        end
        user.add_role role

        return user.has_role? role
    end
end

