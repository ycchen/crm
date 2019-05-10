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

ActiveRecord::Schema.define(version: 33) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_tags", id: :serial, force: :cascade do |t|
    t.integer "contact_id", null: false
    t.integer "tag_id", null: false
    t.index ["contact_id", "tag_id"], name: "index_contact_tags_on_contact_id_and_tag_id", unique: true
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "address2"
    t.string "city"
    t.integer "state_id"
    t.string "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "notes_count", default: 0, null: false
    t.integer "followups_count", default: 0, null: false
    t.datetime "last_contacted"
    t.index ["state_id"], name: "index_contacts_on_state_id"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "custom_fields", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "entity_type_id", null: false
    t.integer "field_type_id", null: false
    t.string "name", limit: 255, null: false
    t.integer "position", default: 0, null: false
    t.boolean "required", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_type_id"], name: "index_custom_fields_on_entity_type_id"
    t.index ["field_type_id"], name: "index_custom_fields_on_field_type_id"
    t.index ["position"], name: "index_custom_fields_on_position"
    t.index ["user_id", "entity_type_id", "name"], name: "index_custom_fields_on_user_id_and_entity_type_id_and_name", unique: true
    t.index ["user_id"], name: "index_custom_fields_on_user_id"
  end

  create_table "entity_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 32
    t.index ["name"], name: "index_entity_types_on_name", unique: true
  end

  create_table "field_options", id: :serial, force: :cascade do |t|
    t.integer "custom_field_id", null: false
    t.string "name", limit: 255
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id", "name"], name: "index_field_options_on_custom_field_id_and_name", unique: true
    t.index ["custom_field_id"], name: "index_field_options_on_custom_field_id"
    t.index ["position"], name: "index_field_options_on_position"
  end

  create_table "field_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 32
    t.index ["name"], name: "index_field_types_on_name", unique: true
  end

  create_table "field_values", id: :serial, force: :cascade do |t|
    t.integer "custom_field_id", null: false
    t.integer "entity_id", null: false
    t.integer "entity_type", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_id", "entity_id", "entity_type"], name: "cf_id_e_id_et_uniq_idx", unique: true
    t.index ["custom_field_id"], name: "index_field_values_on_custom_field_id"
  end

  create_table "followup_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 16
    t.index ["name"], name: "index_followup_types_on_name", unique: true
  end

  create_table "followups", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "contact_id", null: false
    t.integer "followup_type_id", null: false
    t.boolean "completed", default: false, null: false
    t.text "note"
    t.datetime "when", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed"], name: "index_followups_on_completed"
    t.index ["contact_id"], name: "index_followups_on_contact_id"
    t.index ["followup_type_id"], name: "index_followups_on_followup_type_id"
    t.index ["user_id"], name: "index_followups_on_user_id"
    t.index ["when"], name: "index_followups_on_when"
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.integer "contact_id", null: false
    t.text "note", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["contact_id"], name: "index_notes_on_contact_id"
    t.index ["created_at"], name: "index_notes_on_created_at"
  end

  create_table "phone_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 16
    t.index ["name"], name: "index_phone_types_on_name", unique: true
  end

  create_table "phones", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.integer "phone_type_id"
    t.string "number", limit: 11
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_phones_on_contact_id"
    t.index ["phone_type_id"], name: "index_phones_on_phone_type_id"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name", limit: 255
    t.text "desc"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "img_file_name"
    t.string "img_content_type"
    t.integer "img_file_size"
    t.datetime "img_updated_at"
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "providers", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sale_items", id: :serial, force: :cascade do |t|
    t.integer "sale_id"
    t.integer "product_id"
    t.decimal "price", precision: 10, scale: 2
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sale_items_on_product_id"
    t.index ["sale_id"], name: "index_sale_items_on_sale_id"
  end

  create_table "sales", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_sales_on_contact_id"
    t.index ["user_id"], name: "index_sales_on_user_id"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "abbr"
    t.index ["abbr"], name: "index_states_on_abbr", unique: true
    t.index ["name"], name: "index_states_on_name", unique: true
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", limit: 32, null: false
    t.integer "contact_tags_count", default: 0
    t.index ["contact_tags_count"], name: "index_tags_on_contact_tags_count"
    t.index ["user_id", "name"], name: "index_tags_on_user_id_and_name", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 64, null: false
    t.string "fname", limit: 32
    t.string "lname", limit: 32
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "contacts_count", default: 0, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "time_zone", default: "Central Time (US & Canada)", null: false
    t.integer "provider_id"
    t.string "uid", limit: 255
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider_id", "uid"], name: "index_users_on_provider_id_and_uid", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "contacts", "states"
  add_foreign_key "contacts", "users"
  add_foreign_key "custom_fields", "entity_types"
  add_foreign_key "custom_fields", "field_types"
  add_foreign_key "custom_fields", "users"
  add_foreign_key "field_options", "custom_fields"
  add_foreign_key "field_values", "custom_fields"
  add_foreign_key "phones", "contacts"
  add_foreign_key "phones", "phone_types"
  add_foreign_key "products", "users"
  add_foreign_key "sale_items", "products"
  add_foreign_key "sale_items", "sales"
  add_foreign_key "sales", "contacts"
  add_foreign_key "sales", "users"
end
