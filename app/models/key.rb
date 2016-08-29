class Key < ActiveRecord::Base
	has_many :po_ks
	has_many :purchase_orders, through: :po_ks

	#mount_uploader :keyfile, KeyfileUploader
	#validates :name, presence: true
   
	def self.import key_file
		File.foreach( key_file.path ).with_index do |line, index| 
			Rails.logger.debug(line)

			# Create list of IDs and return uploaded Keys
		end
	end
end
