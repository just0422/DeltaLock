class KeyController < ApplicationController
	before_action :set_key, only: [:show, :edit, :update]
	respond_to :html, :js

	def show
        @pok = PoK.find_by_key_id(@key[:key_hash])
    end

	def update
		@key.update_attributes(key_params)
	end
	
	def new
		@key = Key.new
	end

	def create
		@key = Key.new(key_params)

		@key_columns = "<thead><tr>"
		@key_info = "<tbody><tr>"
		Key.column_names.each do |title|
			@key_columns += "<th>" + title + "</th>"
			@key_info += "<td>" + @key[title].to_s + "</td>"
		end
		@key_columns += "</tr></thead>"
		@key_info += "</tr></tbody"
	end

	private
	def key_params
		params.require(:key).permit(:key, :master_key, :control_key, :stamp_code)
	end

	def set_key
		@key = Key.find(params[:id])
	end
end
