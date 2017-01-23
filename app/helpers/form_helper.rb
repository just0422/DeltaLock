module FormHelper
	def setup_item(item)
		item.address ||= Address.new
		item
	end
end
