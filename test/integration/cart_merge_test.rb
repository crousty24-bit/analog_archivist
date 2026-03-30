require "test_helper"

class CartMergeTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.load_seed
    @user = users(:archivist)
    @guest_product = Product.find_by!(slug: "solaris-pinball-cabinet")
    @owned_product = Product.find_by!(slug: "cosmic-voyager-1974")
  end

  test "signing in merges the guest basket into the user basket" do
    owned_cart = Cart.create!(user: @user, session_token: "owned-token")
    owned_cart.add_product(@owned_product, 1)

    post cart_items_path, params: { product_id: @guest_product.id, quantity: 2 }
    guest_cart = Cart.find_by!(user_id: nil)

    sign_in @user
    get shipping_ledger_path

    merged_cart = @user.reload.cart
    assert_equal 3, merged_cart.total_items
    assert_equal 2, merged_cart.cart_items.find_by!(product: @guest_product).quantity
    assert_equal 1, merged_cart.cart_items.find_by!(product: @owned_product).quantity
    assert_nil Cart.find_by(id: guest_cart.id)
  end
end
