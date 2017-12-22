class Relationship < ApplicationRecord
	def self.import(file)
		spreadsheet = ImportFunctions.open_spreadsheet(file)
		header = spreadsheet.row(1)

		(2..spreadsheet.last_row).each do |i|
			row = Hash[[header, spreadsheet.row(i)].transpose]

			relationship = Relationship.find_by_id(row["id"]) || new
			relationship.attributes = row.to_hash.slice(*ColumnTypeXls.keys)
			relationship.save!
		end
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
