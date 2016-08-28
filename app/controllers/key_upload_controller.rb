class KeyUploadController < ApplicationController
	def index
	end

	def create
		Rails.logger.debug(params[:keyfile])
		#@key = Key.new(key_params)
	end

	def new
		@key = Key.new
	end

	def destroy
	end

	private
	def key_params
		params.require(:key).permit(:key, :master_key, :control_key, :stamp_code)
	end
end
