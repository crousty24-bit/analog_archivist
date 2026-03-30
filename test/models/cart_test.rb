require "test_helper"

class CartTest < ActiveSupport::TestCase
  setup do
    @category = Category.create!(
      slug: "cat-trees",
      name: "Cat Trees",
      hero_label: "Cat Trees",
      image_remote_url: "https://example.com/category.jpg"
    )
    @product = Product.create!(category: @category, slug: "spire", title: "Cat Spire", price_cents: 12_500)
    @user = User.create!(email: "cart-owner@example.com", password: "password123", password_confirmation: "password123")
  end

  test "add_product increments an existing line item" do
    cart = Cart.create!(session_token: "guest-token")

    cart.add_product(@product, 1)
    cart.add_product(@product, 2)

    assert_equal 3, cart.cart_items.find_by!(product: @product).quantity
  end

  test "fetch_for merges the guest cart into the signed in cart" do
    guest_cart = Cart.create!(session_token: "guest-token")
    guest_cart.add_product(@product, 2)

    user_cart = Cart.create!(user: @user, session_token: "user-token")
    merged_cart = Cart.fetch_for(user: @user, session_token: guest_cart.session_token)

    assert_equal user_cart, merged_cart
    assert_nil Cart.find_by(id: guest_cart.id)
    assert_equal 2, merged_cart.cart_items.find_by!(product: @product).quantity
  end
end
