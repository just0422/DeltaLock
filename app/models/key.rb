class Key < ApplicationRecord
	include ImportFunctions
	has_many :po_ks
	has_many :purchase_orders, through: :po_ks

	#mount_uploader :keyfile, KeyfileUploader
	#validates :name, presence: true

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

			keycode = Key.find_by_id(row["id"]) || new
			keycode.attributes = row.to_hash.slice(*ColumnTypeXls.keys)
			keycode.save!
		end
	end
end
