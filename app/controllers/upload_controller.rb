class UploadController < ApplicationController
	def index
		@key = Key.new
	end

	def create
	end

	def upload_key 
		Key.import(params[:key][:keyfile])

		Rails.logger.debug("PARAMS[keyfile] --> " + params[:key][:eyfile].to_s)
			
		Rails.logger.debug("FILE\n")
		File.open(params[:key][:keyfile].path, 'r') do |f1|
			while line = f1.gets  
				Rails.logger.debug(line)  
			end  
		end  
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
