class PoK < ActiveRecord::Base
   belongs_to :key
   belongs_to :purchase_order
end
