class Key < ActiveRecord::Base
   has_many :po_ks
   has_many :purchase_orders, through: :po_ks

   #mount_uploader :keyfile, KeyfileUploader
   #validates :name, presence: true
end
