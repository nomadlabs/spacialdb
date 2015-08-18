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

ActiveRecord::Schema.define(version: 20150807205410) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "instances", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "droplet_id"
    t.string   "name"
    t.string   "status"
    t.inet     "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid     "user_id"
    t.integer  "region_id"
  end

  create_table "plans", force: :cascade do |t|
    t.integer "amount",                               null: false
    t.string  "currency",                             null: false
    t.string  "interval",                             null: false
    t.integer "interval_count",       default: 1
    t.string  "name",                                 null: false
    t.integer "trial_period_days"
    t.string  "statement_descriptor"
    t.json    "metadata",             default: {}
    t.boolean "featured",             default: false
  end

  create_table "regions", force: :cascade do |t|
    t.string  "slug",      null: false
    t.string  "name",      null: false
    t.boolean "available"
  end

  create_table "stripe_webhooks", force: :cascade do |t|
    t.string   "stripe_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stripe_webhooks", ["stripe_id"], name: "index_stripe_webhooks_on_stripe_id", using: :btree

  create_table "subscriptions", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.integer  "plan_id"
    t.string   "stripe_subscription_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "state"
    t.uuid     "instance_id"
  end

  create_table "users", id: :uuid, default: "uuid_generate_v4()", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_customer_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["stripe_customer_id"], name: "index_users_on_stripe_customer_id", using: :btree

end
