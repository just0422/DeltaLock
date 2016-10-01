module KeycodesHelper
	def purchaseOrderLinks(id)
		@purchase_orders_list = PurchaseOrder.where("end_user_id like ?", "%#{id}%")
	end

	def pokLink(keyhash)
		@pok = PoK.find_by_key_id(keyhash)
	end
end
