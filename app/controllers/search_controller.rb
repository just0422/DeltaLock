class SearchController < ApplicationController
    authorize_resource Key
    authorize_resource EndUser
    authorize_resource Purchaser 
    authorize_resource PurchaseOrder
    authorize_resource Relationship
	before_action :set_arrays
	after_action :uniq_arrays

    def index
        @purchase_order_search = PurchaseOrder.search
		@purchase_orders_list = @purchase_order_search.result

		@keycodes_search = Key.search
		@keycodes_list = @keycodes_search.result

		@end_users_search = EndUser.search
		@end_users_list = @end_users_search.result

		@purchasers_search = Purchaser.search
		@purchasers_list = @purchasers_search.result
    end

	def result 
        case params[:search_type]
        when "purchase_order_search"
            @class = PurchaseOrder
            @css_class = "purchaseorders"
            @name = "Purchase Orders"
        when "keycodes_search"
            @class = Key
            @css_class = "keycodes"
            @name = "Key Codes"
        when "end_user_search"
            @class = EndUser
            @css_class = "endusers"
            @name = "End Users"
        when "purchaser_search"
            @class = Purchaser
            @css_class = "purchasers"
            @name = "Purchaser"
        when "assignment_search"
            @class = Relationship
            @css_class = "assignments"
            @name = "Assignments"
        end
        
        @search = @class.search(params[:q])
        @list = @search.result
        @search.build_condition if @search.conditions.empty?
        @search.build_sort if @search.sorts.empty?

        respond_to do |format|
            format.js
        end
    end

	private
	def set_arrays
        @end_users_list = Array.new
        @key_codes_list = Array.new
        @purchase_orders_list = Array.new
        @purchasers_list = Array.new
        @assignments_list = Array.new
	end

	def uniq_arrays
        @end_users_list = @end_users_list.uniq.compact
        @key_codes_list = @key_codes_list.uniq.compact
        @purchase_orders_list = @purchase_orders_list.uniq.compact
        @purchasers_list = @purchasers_list.uniq.compact
        @assignments_list = @purchasers_list.uniq.compact
	end
end
