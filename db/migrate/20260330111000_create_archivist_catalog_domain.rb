class CreateArchivistCatalogDomain < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :hero_label, null: false
      t.string :image_remote_url
      t.string :image_alt_text
      t.integer :sort_position, null: false, default: 0

      t.timestamps
    end

    add_index :categories, :slug, unique: true

    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.string :slug, null: false
      t.string :title, null: false
      t.string :archive_number
      t.string :sku
      t.string :subtitle
      t.integer :price_cents, null: false, default: 0
      t.string :badge
      t.string :material
      t.string :availability
      t.text :short_description
      t.text :detail_quote
      t.text :detail_body
      t.string :story_title
      t.text :story_body
      t.integer :sort_position, null: false, default: 0

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :sku, unique: true

    create_table :product_images do |t|
      t.references :product, null: false, foreign_key: true
      t.string :role, null: false
      t.integer :position, null: false, default: 0
      t.string :remote_url, null: false
      t.string :alt_text

      t.timestamps
    end

    add_index :product_images, [ :product_id, :role, :position ]

    create_table :product_specifications do |t|
      t.references :product, null: false, foreign_key: true
      t.string :label, null: false
      t.string :value, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :product_specifications, [ :product_id, :position ]

    create_table :newsletter_subscriptions do |t|
      t.string :email, null: false

      t.timestamps
    end

    add_index :newsletter_subscriptions, :email, unique: true

    create_table :carts do |t|
      t.references :user, foreign_key: true, index: { unique: true }
      t.string :session_token, null: false

      t.timestamps
    end

    add_index :carts, :session_token, unique: true

    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end

    add_index :cart_items, [ :cart_id, :product_id ], unique: true

    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :street_address, null: false
      t.string :city_province, null: false
      t.string :postal_code, null: false
      t.boolean :billing_matches_shipping, null: false, default: true
      t.string :shipping_method, null: false
      t.integer :shipping_amount_cents, null: false, default: 0
      t.integer :tax_amount_cents, null: false, default: 0
      t.integer :subtotal_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0
      t.string :manifest_number, null: false
      t.string :status, null: false, default: "submitted"

      t.timestamps
    end

    add_index :orders, :manifest_number, unique: true

    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, foreign_key: true
      t.string :title, null: false
      t.string :sku
      t.string :archive_number
      t.integer :unit_price_cents, null: false, default: 0
      t.integer :quantity, null: false, default: 1
      t.integer :line_total_cents, null: false, default: 0

      t.timestamps
    end
  end
end
