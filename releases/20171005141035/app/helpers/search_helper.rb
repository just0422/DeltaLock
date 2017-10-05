module SearchHelper
	def purchaseOrderLinks(id)
		@purchaseorders_list = PurchaseOrder.where("end_user_id like ?", "%#{id}%")
	end

	def pokLink(keyhash)
		@pok = PoK.find_by_key_id(keyhash)
	end

	def purchaserEnduserKeyLinks(po)
		@purchaser = Purchaser.find_by_id(po[:purchaser_id])
		@end_user = EndUser.find_by_id(po[:end_user_id])

		poks = PoK.where(purchase_order_id: po[:id])
		@keys_list = Array.new

		poks.each do |po_k|
			@keys_list.push(Key.find(po_k[:key_id]))
		end
	end
end
