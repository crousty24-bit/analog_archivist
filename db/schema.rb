# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_03_30_111000) do
  create_table "cart_items", force: :cascade do |t|
    t.integer "cart_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id", "product_id"], name: "index_cart_items_on_cart_id_and_product_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.integer "user_id"
    t.string "session_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_token"], name: "index_carts_on_session_token", unique: true
    t.index ["user_id"], name: "index_carts_on_user_id", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.string "hero_label", null: false
    t.string "image_remote_url"
    t.string "image_alt_text"
    t.integer "sort_position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "newsletter_subscriptions", force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_newsletter_subscriptions_on_email", unique: true
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "product_id"
    t.string "title", null: false
    t.string "sku"
    t.string "archive_number"
    t.integer "unit_price_cents", default: 0, null: false
    t.integer "quantity", default: 1, null: false
    t.integer "line_total_cents", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "street_address", null: false
    t.string "city_province", null: false
    t.string "postal_code", null: false
    t.boolean "billing_matches_shipping", default: true, null: false
    t.string "shipping_method", null: false
    t.integer "shipping_amount_cents", default: 0, null: false
    t.integer "tax_amount_cents", default: 0, null: false
    t.integer "subtotal_cents", default: 0, null: false
    t.integer "total_cents", default: 0, null: false
    t.string "manifest_number", null: false
    t.string "status", default: "submitted", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manifest_number"], name: "index_orders_on_manifest_number", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "product_images", force: :cascade do |t|
    t.integer "product_id", null: false
    t.string "role", null: false
    t.integer "position", default: 0, null: false
    t.string "remote_url", null: false
    t.string "alt_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "role", "position"], name: "index_product_images_on_product_id_and_role_and_position"
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "product_specifications", force: :cascade do |t|
    t.integer "product_id", null: false
    t.string "label", null: false
    t.string "value", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "position"], name: "index_product_specifications_on_product_id_and_position"
    t.index ["product_id"], name: "index_product_specifications_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.string "archive_number"
    t.string "sku"
    t.string "subtitle"
    t.integer "price_cents", default: 0, null: false
    t.string "badge"
    t.string "material"
    t.string "availability"
    t.text "short_description"
    t.text "detail_quote"
    t.text "detail_body"
    t.string "story_title"
    t.text "story_body"
    t.integer "sort_position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["sku"], name: "index_products_on_sku", unique: true
    t.index ["slug"], name: "index_products_on_slug", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "orders", "users"
  add_foreign_key "product_images", "products"
  add_foreign_key "product_specifications", "products"
  add_foreign_key "products", "categories"
end
