# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160817185432) do

  create_table "end_users", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "address",      limit: 255
    t.string   "email",        limit: 255
    t.string   "phone",        limit: 255
    t.string   "department",   limit: 255
    t.integer  "store_number", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "group_id",     limit: 4
    t.float    "lat",          limit: 24
    t.float    "lng",          limit: 24
  end

  add_index "end_users", ["group_id"], name: "index_end_users_on_group_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "keys", primary_key: "key_hash", force: :cascade do |t|
    t.string   "key",         limit: 255
    t.string   "master_key",  limit: 255
    t.string   "control_key", limit: 255
    t.string   "stamp_code",  limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "po_ks", force: :cascade do |t|
    t.integer  "quantity",          limit: 4
    t.integer  "key_id",            limit: 4
    t.integer  "purchase_order_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "po_ks", ["key_id"], name: "index_po_ks_on_key_id", using: :btree
  add_index "po_ks", ["purchase_order_id"], name: "index_po_ks_on_purchase_order_id", using: :btree

  create_table "purchase_orders", primary_key: "so_number", force: :cascade do |t|
    t.integer  "po_number",    limit: 4
    t.date     "date_order"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "purchaser_id", limit: 4
    t.integer  "end_user_id",  limit: 4
  end

  add_index "purchase_orders", ["end_user_id"], name: "index_purchase_orders_on_end_user_id", using: :btree
  add_index "purchase_orders", ["purchaser_id"], name: "index_purchase_orders_on_purchaser_id", using: :btree

  create_table "purchasers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.string   "email",      limit: 255
    t.string   "phone",      limit: 255
    t.string   "fax",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "end_users", "groups"
  add_foreign_key "purchase_orders", "end_users"
  add_foreign_key "purchase_orders", "purchasers"
end
