class HomePageController < ApplicationController
    def index
        if user_signed_in?
            render :layout => false
        else
            redirect_to '/users/sign_in'
        end
    end
end
