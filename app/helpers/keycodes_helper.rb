module KeycodesHelper
	def purchaseOrderLinks(id)
		@purchase_orders_list = PurchaseOrder.where("end_user_id like ?", "%#{id}%")
	end
end
