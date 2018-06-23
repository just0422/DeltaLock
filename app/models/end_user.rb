class EndUser < ApplicationRecord
	include ImportFunctions
    resourcify

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
        return ImportFunctions.importClass(EndUser, spreadsheet)
	end

	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
		csv << column_names
		all.each do |product|
		  csv << product.attributes.values_at(*column_names)
		end
	  end
	end	

end
