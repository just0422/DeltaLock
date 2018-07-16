class Key < ApplicationRecord
	include ImportFunctions
    resourcify

    # All fields are searchable except the ones listed in []
	def self.ransackable_attributes(auth_object = nil)
		super - ['created_at', 'updated_at']
	end

    # Import a file into the database
    #
    # Params:
    #   file - the file to be imported
	def self.import(file)
		spreadsheet = ImportFunctions.open_spreadsheet(file)
        return ImportFunctions.importClass(Key, spreadsheet)
	end

    # Export a file to CSV
	def self.to_csv(options = {})
	  CSV.generate(options) do |csv|
		csv << column_names
		all.each do |product|
		  csv << product.attributes.values_at(*column_names)
		end
	  end
	end	
end
