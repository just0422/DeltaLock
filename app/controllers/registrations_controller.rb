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
        super

        user = User.find(resource.id)
        user.add_role params[:role]

        @users = User.all
    end
end

