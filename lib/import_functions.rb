module ImportFunctions
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-1:utf-8"})
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
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
