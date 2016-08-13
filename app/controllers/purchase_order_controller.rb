class PurchaseOrderController < ApplicationController
    def show
        @purchaseorder = PurchaseOrder.find(params[:id])
        @purchaser = Purchaser.find(@purchaseorder[:purchaser_id])
        @end_user = EndUser.find(@purchaseorder[:end_user_id])
        
        poks = PoK.where(purchase_order_id: params[:id])
        @keys_list = Array.new

        poks.each do |po_k|
            @keys_list.push(Key.find(po_k[:key_id]))
        end
    end
end
