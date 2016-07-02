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

ActiveRecord::Schema.define(version: 20160702193521) do

  create_table "end_users", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "address",      limit: 255
    t.string   "email",        limit: 255
    t.string   "phone",        limit: 255
    t.string   "detpartment",  limit: 255
    t.integer  "store_number", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "keys", force: :cascade do |t|
    t.integer  "key_hash",    limit: 4,   null: false
    t.integer  "primary_key", limit: 4,   null: false
    t.string   "key",         limit: 255
    t.string   "master_key",  limit: 255
    t.string   "control_key", limit: 255
    t.string   "stamp_code",  limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "po_ks", force: :cascade do |t|
    t.integer  "quanitity",         limit: 4
    t.integer  "key_id",            limit: 4
    t.integer  "purchase_order_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "po_ks", ["key_id"], name: "index_po_ks_on_key_id", using: :btree
  add_index "po_ks", ["purchase_order_id"], name: "index_po_ks_on_purchase_order_id", using: :btree

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "so_number",   limit: 4
    t.integer  "primary_key", limit: 4
    t.integer  "po_number",   limit: 4
    t.date     "date_order"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "purchasers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "address",    limit: 255
    t.string   "email",      limit: 255
    t.string   "phone",      limit: 255
    t.string   "fax",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end