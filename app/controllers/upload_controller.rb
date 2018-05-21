require 'rubygems'
require 'json'
require 'roo'
require 'csv'

class UploadController < ApplicationController
	def index
	end

	def new
	end

	def create
		#Rails.logger.debug("PARAMS --> " + JSON.pretty_generate(params))
		#Key.import(params[:key][:keyfile])*/

		case params[:category]
		when "endusers"
			EndUser.import(params[:file])
		when "purchasers"
			Purchaser.import(params[:file])
		when "purchaseorders"
			PurchaseOrder.import(params[:file])
		when "keycodes"
			Key.import(params[:file])
		when "assignments"
			Relationship.import(params[:file])
		end
	end

	def destroy
	end
end
