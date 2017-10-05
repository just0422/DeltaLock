class UsersController < ApplicationController
	respond_to :js

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			session[:user_id]= @user.id
			redirect_to '/'
		else
			redirect_to '/signup'
		end
	end

	def update
		puts(user_params)
		user = User.find(params[:id])
		user.update_attributes(user_params)

		render :nothing => true
	end

	def destroy
		User.destroy(params[:id])
		render :nothing => true
	end

	def user_management
		@all_users = User.all
	end

private
  def user_params
	params.require(:user).permit(:first_name, :last_name, :username, :password, :role)
	end
end
