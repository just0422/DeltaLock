class PurchaseOrder < ActiveRecord::Base
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
      header = spreadsheet.row(1)

      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        purchase_order = PurchaseOrder.find_by_id(row["id"]) || new
        purchase_order.attributes = row.to_hash.slice(*accessible_attributes)
        purchase_order.save!
      end
    end
end
