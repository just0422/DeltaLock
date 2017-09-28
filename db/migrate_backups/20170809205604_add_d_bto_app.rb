class AddDBtoApp < ActiveRecord::Migration
	def change
		create_table "addresses", force: :cascade do |t|
			t.datetime "created_at",                       null: false
			t.datetime "updated_at",                       null: false
			t.integer  "addressable_id",   limit: 4
			t.string   "addressable_type", limit: 255
			t.string   "line1",            limit: 255
			t.string   "line2",            limit: 255
			t.string   "city",             limit: 255
			t.string   "state",            limit: 255
			t.string   "zip",              limit: 255
			t.string   "country",          limit: 255
			t.string   "custom_address",   limit: 255
		end

		add_index "addresses", ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id", unique: true, using: :btree

		create_table "end_users", force: :cascade do |t|
			t.datetime "created_at",                       null: false
			t.datetime "updated_at",                       null: false
			t.string   "name",                 limit: 255
			t.string   "phone",                limit: 255
			t.string   "fax",                  limit: 255
			t.string   "group_name",           limit: 255
			t.string   "department",           limit: 255
			t.integer  "store_number",         limit: 4
			t.string   "primary_contact",      limit: 255
			t.string   "primary_contact_type", limit: 255
			t.string   "sub_department_1",     limit: 255
			t.string   "sub_department_2",     limit: 255
			t.string   "sub_department_3",     limit: 255
			t.string   "sub_department_4",     limit: 255
			t.integer  "address_id",           limit: 4
			t.float    "lat",                  limit: 24
			t.float    "lng",                  limit: 24
		end

		add_index "end_users", ["address_id"], name: "fk_rails_365732cfc2", using: :btree

		create_table "keys", force: :cascade do |t|
			t.datetime "created_at",                       null: false
			t.datetime "updated_at",                       null: false
			t.string   "keyway",        limit: 255
			t.string   "master_key",    limit: 255
			t.string   "control_key",   limit: 255
			t.string   "operating_key", limit: 255
			t.string   "bitting",       limit: 255
			t.string   "system_name",   limit: 255
			t.text     "comments",      limit: 4294967295
		end

		create_table "po_ks", force: :cascade do |t|
			t.datetime "created_at",                  null: false
			t.datetime "updated_at",                  null: false
			t.integer  "quantity",          limit: 4
			t.integer  "key_id",            limit: 4
			t.integer  "purchase_order_id", limit: 4
		end

		add_index "po_ks", ["key_id"], name: "index_po_ks_on_key_id", using: :btree
		add_index "po_ks", ["purchase_order_id"], name: "index_po_ks_on_purchase_order_id", using: :btree

		create_table "purchase_orders", primary_key: "so_number", force: :cascade do |t|
			t.datetime "created_at",             null: false
			t.datetime "updated_at",             null: false
			t.integer  "po_number",    limit: 4
			t.date     "date_order"
			t.integer  "purchaser_id", limit: 4
			t.integer  "end_user_id",  limit: 4
		end

		add_index "purchase_orders", ["end_user_id"], name: "index_purchase_orders_on_end_user_id", using: :btree
		add_index "purchase_orders", ["purchaser_id"], name: "index_purchase_orders_on_purchaser_id", using: :btree

		create_table "purchasers", force: :cascade do |t|
			t.datetime "created_at",                       null: false
			t.datetime "updated_at",                       null: false
			t.string   "name",                 limit: 255
			t.string   "phone",                limit: 255
			t.string   "fax",                  limit: 255
			t.string   "primary_contact",      limit: 255
			t.string   "primary_contact_type", limit: 255
			t.integer  "address_id",           limit: 4
			t.string   "group_name",           limit: 255
		end

		add_index "purchasers", ["address_id"], name: "fk_rails_0ef4eb6c71", using: :btree

		create_table "users", force: :cascade do |t|
			t.datetime "created_at",                  null: false
			t.datetime "updated_at",                  null: false
			t.string   "first_name",      limit: 255
			t.string   "last_name",       limit: 255
			t.string   "username",        limit: 255
			t.string   "password_digest", limit: 255
			t.string   "role",            limit: 255
		end

		add_foreign_key "end_users", "addresses"
		add_foreign_key "purchase_orders", "end_users"
		add_foreign_key "purchase_orders", "purchasers"
		add_foreign_key "purchasers", "addresses"
	end
end
