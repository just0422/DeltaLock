# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171029193637) do

  create_table "end_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "name"
    t.string   "phone"
    t.string   "fax"
    t.string   "group_name"
    t.string   "department"
    t.integer  "store_number"
    t.string   "primary_contact"
    t.string   "primary_contact_type"
    t.string   "sub_department_1"
    t.string   "sub_department_2"
    t.string   "sub_department_3"
    t.string   "sub_department_4"
    t.float    "lat",                  limit: 24
    t.float    "lng",                  limit: 24
    t.text     "address",              limit: 65535
    t.index ["id"], name: "index_end_users_on_id", using: :btree
  end

  create_table "keys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "keyway"
    t.string   "master_key"
    t.string   "control_key"
    t.string   "operating_key"
    t.string   "bitting"
    t.string   "system_name"
    t.text     "comments",      limit: 4294967295
    t.index ["id"], name: "index_keys_on_id", using: :btree
  end

  create_table "purchase_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "po_number"
    t.integer "so_number"
    t.date    "date_order"
    t.integer "purchaser_id"
    t.integer "end_user_id"
    t.index ["id"], name: "index_purchase_orders_on_id", using: :btree
  end

  create_table "purchasers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "name"
    t.string   "phone"
    t.string   "fax"
    t.string   "primary_contact"
    t.string   "primary_contact_type"
    t.string   "group_name"
    t.text     "address",              limit: 65535
    t.index ["id"], name: "index_purchasers_on_id", using: :btree
  end

  create_table "relationship", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "purchase_order_id"
    t.integer "purchaser_id"
    t.integer "end_user_id"
    t.integer "key_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "password_digest"
    t.string   "role"
  end

end
