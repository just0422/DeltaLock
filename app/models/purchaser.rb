class Purchaser < ApplicationRecord
  include ImportFunctions
    has_many :purchase_orders


	validates :name, presence: true

  #attr_accessible :name, :line1
  # TODO: Fix this!!!!!!
	def self.ransackable_attributes(auth_object = nil)
		super - ['created_at', 'updated_at']
	end

  def self.import(file)
    spreadsheet = ImportFunctions.open_spreadsheet(file)
    header = spreadsheet.row(1)

    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]

      purchaser = Purchaser.find_by_id(row["id"]) || new
      purchaser.attributes = row.to_hash.slice(*ColumnTypeXls.keys)
      purchaser.save!
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
