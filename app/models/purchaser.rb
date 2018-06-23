class Purchaser < ApplicationRecord
  include ImportFunctions
    resourcify

    has_many :purchase_orders


	validates :name, presence: true

  #attr_accessible :name, :line1
  # TODO: Fix this!!!!!!
	def self.ransackable_attributes(auth_object = nil)
		super - ['created_at', 'updated_at']
	end

  def self.import(file)
    spreadsheet = ImportFunctions.open_spreadsheet(file)
    return ImportFunctions.importClass(Purchaser, spreadsheet)
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
