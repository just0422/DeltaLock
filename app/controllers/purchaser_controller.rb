class PurchaserController < ApplicationController
    def show 
        @purchaser = Purchaser.find(params[:id])
        @purchase_orders_list = PurchaseOrder.where("purchaser_id like ?", "%#{params[:id]}%")
    end
end
