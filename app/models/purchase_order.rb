class PurchaseOrder < ActiveRecord::Base
    belongs_to :purchaser
    has_many :po_ks
    has_many :keys, through: :po_ks
end
