class EndUser < ApplicationRecord
	include ImportFunctions
	has_many :purchase_orders

	acts_as_mappable :default_units => :miles,
					 :default_formula => :sphere,
					 :distance_field_name => :distance,
					 :lat_column_name => :lat,
					 :lng_column_name => :lng

	validates :name, presence: true


	def self.ransackable_attributes(auth_object = nil)
		super - ['created_at', 'updated_at', 'lat', 'lng']
	end

	def self.import(file)
		spreadsheet = ImportFunctions.open_spreadsheet(file)
		header = spreadsheet.row(1)

		(2..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]

			end_user = EndUser.find_by_id(row["id"]) || new
			end_user.attributes = row.to_hash.slice(*ColumnTypeXls.keys)
			end_user.save!
		end
	end

	

end
