require 'rubygems'
require 'json'
require 'roo'
require 'csv'

class UploadController < ApplicationController
	def index
		end_user  = ['name', 'phone', 'department', 'store_number',
			   		 'primary_contact', 'primary_contact_type', 'sub_department_1',
					 'sub_department_2', 'sub_department_3', 'sub_department_4',
					 'fax', 'group_name', 'address_id']

		key       = ['keyway', 'master_key', 'control_key', 'operating_key',
			   		 'bitting', 'system_name', 'comment']

		purchaser = ['name', 'phone', 'fax', 'primary_contact',
			   		 'primary_contact_type', 'group_name', 'address_id']

		user	  = ['first_name', 'last_name', 'username', 'password_digest',
					 'role']

		purchase_order = ['po_number', 'date_order', 'purchaser_id', 'end_user_id']
	end

	def create
		#Rails.logger.debug("PARAMS --> " + JSON.pretty_generate(params))
		#Key.import(params[:key][:keyfile])*/

		case params[:category]
		when "end_user"
			EndUser.import(params[:file])
		when "purchaser"
			Purchaser.import(params[:file])
		when "purchase_order"
			PurchaseOrder.import(params[:file])
		when "keycode"
			Key.import(params[:file])
		when "assignment"
			Relationship.import(params[:file])
		end
		# xls = Roo::Spreadsheet.open(params[:file].path.to_s, 'r')
		# Rails.logger.debug(xls.info)
		# sheet = xls.sheet(0)
=begin
		sheet.each do |line|
		case params[:category]
		when "end_user"
			title_line = f1.gets.rstrip.split(",")
			Rails.logger.debug("Title - " + title_line.to_s + "\n")
			while line = f1.gets
				line_split = line.rstrip.split(",")
				enduser_hash = Hash[title_line.zip line_split];
				enduser_hash[:store_number] = enduser_hash[:store_number].to_i
				Rails.logger.debug(JSON.pretty_generate(enduser_hash))
				#EndUser.create(enduser_hash)
			end
		when "key"
			title_line = f1.gets.split(",").squish
			while line = f1.gets
				line_split = line.split(",").squish
				Key.create(Hash[title_line.zip line_split])
			end
		when "purchaser"
			title_line = f1.gets.split(",").squish
			while line = f1.gets
				line_split = line.split(",").squish
				Purchaser.create(Hash[title_line.zip line_split])
			end
		when "purchase_order"
			title_line = f1.gets.split(",").squish
			while line = f1.gets
				line_split = line.split(",").squish
				PurchaseOrder.create(Hash[title_line.zip line_split])
			end
		end
		#@key = Key.new(key_params)*/
		end
=end
	end

	def new
		@key = Key.new
	end

	def destroy
	end
end
