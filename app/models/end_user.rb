class EndUser < ActiveRecord::Base
	has_one :address, :as => :addressable
	accepts_nested_attributes_for :address

    acts_as_mappable :default_units => :miles,
                     :default_formula => :sphere,
                     :distance_field_name => :distance,
                     :lat_column_name => :lat,
                     :lng_column_name => :lng

	validates :name, presence: true
#	validates_associated :address
end
