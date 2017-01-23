class Purchaser < ActiveRecord::Base
    has_many :purchase_orders
	
	has_one :address, :as => :addressable
	accepts_nested_attributes_for :address

	validates :name, presence: true
end
