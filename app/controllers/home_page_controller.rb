class HomePageController < ApplicationController
    # index function for the home page
    def index
        # if the user is signed in, 
        if user_signed_in?
            # app/views/home_page/index.html.erb is rendered
            render :layout => false # Prevents the navbar from being rendered
        else
            # Otherwise, the user is directed to the sign in page
            redirect_to '/users/sign_in'
        end
    end
end
