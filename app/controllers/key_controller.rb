class KeyController < ApplicationController
	before_action :set_key, only: [:show, :edit, :update]
	respond_to :html, :js

	def show
        @pok = PoK.find_by_key_id(@key[:key_hash])
    end

	def update
		@key.update_attributes(key_params)
	end

	private
	def key_params
		params.require(:key).permit(:key, :master_key, :control_key, :stamp_code)
	end

	def set_key
		@key = Key.find(params[:id])
	end
end
