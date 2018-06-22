class RegistrationsController < Devise::RegistrationsController
    respond_to :js

    def new
        super

        @options = [
            ["Administrator", "admin"],
            ["Editor", "editor"],
            ["Viewer", "viewer"]
        ]
    end

	def create
        Rails.logger.debug("createing")
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

	def destroy
        user = User.find(params[:id])

        user.destroy
        Devise.sign_out_all_scopes ? sign_out : sign_out(:user)
        set_flash_message! :notice, :destroyed
        
        @users = User.all
        render "manage"
    end
    
    protected
    def authenticate_scope!
    end

    def sign_up_params
        params.require(:user).permit(:username, :email, :password, :first_name, :last_name)
    end
end

