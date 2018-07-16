class Relationship < ApplicationRecord
    resourcify

    # Import a file into the database
    #
    # Params:
    #   file - the file to be imported
	def self.import(file)
		spreadsheet = ImportFunctions.open_spreadsheet(file)
        return ImportFunctions.importClass(Relationship, spreadsheet)
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
