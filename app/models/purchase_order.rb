class PurchaseOrder < ApplicationRecord
  include ImportFunctions
    belongs_to :purchaser
	belongs_to :end_user
    has_many :po_ks
    has_many :keys, through: :po_ks

    #attr_accessible :name, :line1
    # TODO: Fix this!!!!!!
	def self.ransackable_attributes(auth_object = nil)
		super - ['created_at', 'updated_at', 'end_user_id', 'purchaser_id']
	end

    def self.import(file)
      spreadsheet = ImportFunctions.open_spreadsheet(file)
      return ImportFunctions.importClass(PurchaseOrder, spreadsheet)
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
