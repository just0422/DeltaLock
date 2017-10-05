class Purchaser < ActiveRecord::Base
  include ImportFunctions
    has_many :purchase_orders

	has_one :address, :as => :addressable
	accepts_nested_attributes_for :address

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
end
