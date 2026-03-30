require "test_helper"

class OrderTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(email: "buyer@example.com", password: "password123", password_confirmation: "password123")
    @category = Category.create!(
      slug: "oil-lamps",
      name: "Oil Lamps",
      hero_label: "Oil Lamps",
      image_remote_url: "https://example.com/category.jpg"
    )
    @product = Product.create!(
      category: @category,
      slug: "beacon",
      title: "Beacon",
      sku: "OL-001",
      archive_number: "#3321",
      price_cents: 2500
    )
    @cart = Cart.create!(user: @user, session_token: "owned-token")
    @cart.add_product(@product, 2)
  end

  test "populate_from_cart snapshots the cart and computes preview totals" do
    order = @user.orders.build(
      full_name: "Ada Archivist",
      email: "ADA@example.com",
      street_address: "123 Archive Way",
      city_province: "Paris",
      postal_code: "75001",
      shipping_method: "pony_express_premium"
    )

    order.populate_from_cart!(@cart)

    assert order.valid?
    assert_equal "submitted", order.status
    assert_equal "ada@example.com", order.email
    assert_equal 5000, order.subtotal_cents
    assert_equal 3850, order.shipping_amount_cents
    assert_equal 400, order.tax_amount_cents
    assert_equal 9250, order.total_cents
    assert_equal 1, order.order_items.size

    item = order.order_items.first
    assert_equal @product, item.product
    assert_equal "Beacon", item.title
    assert_equal "OL-001", item.sku
    assert_equal "#3321", item.archive_number
    assert_equal 2500, item.unit_price_cents
    assert_equal 2, item.quantity
    assert_equal 5000, item.line_total_cents
  end

  test "invalid shipping methods fail validation instead of raising" do
    order = @user.orders.build(
      full_name: "Ada Archivist",
      email: "ada@example.com",
      street_address: "123 Archive Way",
      city_province: "Paris",
      postal_code: "75001",
      shipping_method: "airship"
    )

    order.populate_from_cart!(@cart)

    assert_not order.valid?
    assert_includes order.errors[:shipping_method], "is not included in the list"
  end
end
