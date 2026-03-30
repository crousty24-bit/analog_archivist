require "test_helper"

class StorefrontFlowTest < ActionDispatch::IntegrationTest
  setup do
    Rails.application.load_seed
    @user = users(:archivist)
    @catalog_product = Product.find_by!(slug: "cosmic-voyager-1974")
    @detail_product = Product.find_by!(slug: "solaris-pinball-cabinet")
  end

  test "home, catalog, and product pages render the preview-backed storefront" do
    get root_path
    assert_response :success
    assert_includes @response.body, "The Fine Art of"
    assert_includes @response.body, "The Bally &#39;74 Resurrection"

    get catalog_index_path
    assert_response :success
    assert_includes @response.body, "The Collected"
    assert_includes @response.body, @catalog_product.title

    get catalog_path(@detail_product)
    assert_response :success
    assert_includes @response.body, "Solaris"
    assert_includes @response.body, "Technical Ledger"
  end

  test "catalog filtering and sorting follow the selected query params" do
    get catalog_index_path, params: { category: "oil-lamps", sort: "price-desc" }

    assert_response :success
    assert_includes @response.body, "Cerulean Glass Lanterns"
    assert_includes @response.body, "The Admiral&#39;s Beacon"
    refute_includes @response.body, "The Cosmic Voyager (1974)"
    assert_operator @response.body.index("Cerulean Glass Lanterns"), :<, @response.body.index("The Admiral&#39;s Beacon")
  end

  test "guests can add to the basket but must sign in to finalize checkout" do
    assert_difference("CartItem.count", 1) do
      post cart_items_path, params: { product_id: @detail_product.id, quantity: 1 }
    end

    follow_redirect!
    assert_response :success
    assert_includes @response.body, "The 1968 &#39;Solaris&#39; Pinball Cabinet"

    get shipping_ledger_path
    assert_response :success
    assert_includes @response.body, "The 1968 &#39;Solaris&#39; Pinball Cabinet"

    assert_no_difference("Order.count") do
      post orders_path, params: {
        order: {
          full_name: "Arthur Archivist",
          email: "arthur@example.com",
          street_address: "123 Oak Street",
          city_province: "Paris",
          postal_code: "75001",
          shipping_method: "overland_carriage",
          billing_matches_shipping: "1"
        }
      }
    end

    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_includes @response.body, "Return to the private ledger"
  end

  test "signed in users can finalize an order and the basket is emptied" do
    sign_in @user
    post cart_items_path, params: { product_id: @detail_product.id, quantity: 2 }

    assert_difference("Order.count", 1) do
      post orders_path, params: {
        order: {
          full_name: "Ada Archivist",
          email: "Ada@example.com",
          street_address: "123 Archive Way",
          city_province: "Paris",
          postal_code: "75001",
          shipping_method: "pony_express_premium",
          billing_matches_shipping: "1"
        }
      }
    end

    assert_redirected_to shipping_ledger_path

    order = Order.order(:id).last
    assert_equal @user, order.user
    assert_equal "ada@example.com", order.email
    assert_equal 1, order.order_items.count
    assert_equal 2, order.order_items.first.quantity
    assert_not_nil @user.reload.cart
    assert_equal 0, @user.cart.total_items
  end

  test "newsletter submissions are persisted from the preview forms" do
    assert_difference("NewsletterSubscription.count", 1) do
      post newsletter_subscriptions_path, params: {
        newsletter_subscription: { email: " Curator@Example.com " }
      }
    end

    assert_redirected_to root_path
    assert_equal "curator@example.com", NewsletterSubscription.order(:id).last.email
  end
end
