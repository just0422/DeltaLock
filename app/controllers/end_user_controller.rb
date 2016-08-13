class EndUserController < ApplicationController
    def show 
        @enduser = EndUser.find(params[:id])
        @purchase_orders_list = PurchaseOrder.where("end_user_id like ?", "%#{params[:id]}%")
    end
end
