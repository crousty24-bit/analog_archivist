module ApplicationHelper
  HOME_CATEGORY_TILE_COPY = {
    "pinball" => {
      layout_class: "md:col-span-2 md:row-span-2",
      title_class: "text-3xl",
      teaser: "18 Restoration Units Available"
    },
    "trading-cards" => {
      layout_class: "md:col-span-2",
      title_class: "text-2xl",
      teaser: "The Heritage Series"
    },
    "cat-trees" => {
      layout_class: "",
      title_class: "text-xl",
      teaser: nil
    },
    "oil-lamps" => {
      layout_class: "",
      title_class: "text-xl",
      teaser: nil
    }
  }.freeze
  FOOTER_LINKS = [
    { label: "Our Story", path: nil },
    { label: "Shipping Ledger", path: :shipping_ledger_path },
    { label: "Archive Access", path: :new_user_session_path },
    { label: "Privacy Policy", path: nil }
  ].freeze

  def active_category_slug
    return @selected_category.slug if defined?(@selected_category) && @selected_category.present?
    return @product.category.slug if defined?(@product) && @product.present?

    nil
  end

  def archive_price(amount_cents, strip_zero_cents: true)
    precision = strip_zero_cents && amount_cents.to_i % 100 == 0 ? 0 : 2
    number_to_currency(amount_cents.to_i / 100.0, precision: precision)
  end

  def cart_summary_totals(order, cart = current_cart)
    shipping_method = order.shipping_method if Order.shipping_options.key?(order.shipping_method)
    shipping_method ||= Order::DEFAULT_SHIPPING_METHOD
    shipping_amount = Order.shipping_options.fetch(shipping_method).fetch(:amount_cents)
    subtotal = cart.subtotal_cents
    tax = Order.tax_amount_for(subtotal)

    {
      shipping_amount_cents: shipping_amount,
      subtotal_cents: subtotal,
      tax_amount_cents: tax,
      total_cents: subtotal + shipping_amount + tax
    }
  end

  def current_account_path
    user_signed_in? ? edit_user_registration_path : new_user_session_path
  end

  def footer_links
    FOOTER_LINKS.map do |entry|
      entry.merge(url: entry[:path] ? public_send(entry[:path]) : nil)
    end
  end

  def home_category_tile_copy(category)
    HOME_CATEGORY_TILE_COPY.fetch(category.slug)
  end

  def navigation_categories
    return [] unless Category.table_exists?

    Category.ordered.where(slug: %w[cat-trees pinball trading-cards oil-lamps])
  end

  def product_heading_segments(product)
    return [ "The 1968 'Solaris'", "Pinball Cabinet" ] if product.slug == "solaris-pinball-cabinet"

    [ product.title, nil ]
  end

  def product_identity_rows(product)
    rows = []
    rows << [ "Archive No.", product.archive_number ] if product.archive_number.present?
    rows << [ "Stock Code", product.sku ] if product.sku.present?
    value = product.primary_identity_value
    rows << [ product.primary_identity_label, value ] if value.present?
    rows.first(3)
  end

  def product_spec_rows(product)
    rows = product.product_specifications.map { |spec| [ spec.label, spec.value ] }
    return rows if rows.any?

    fallback_rows = []
    fallback_rows << [ "Category", product.category.name ]
    fallback_rows << [ "Archive No.", product.archive_number ] if product.archive_number.present?
    fallback_rows << [ "Stock Code", product.sku ] if product.sku.present?
    fallback_rows << [ product.primary_identity_label, product.primary_identity_value ] if product.primary_identity_value.present?
    fallback_rows << [ "Availability", product.availability ] if product.availability.present?
    fallback_rows.first(5)
  end

  def site_title
    "The Analog Archivist"
  end
end
