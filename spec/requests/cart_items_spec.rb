require "rails_helper"

RSpec.describe "CartItems", type: :request do
  before do
    Rails.application.load_seed
  end

  let(:product) { Product.find_by!(slug: "solaris-pinball-cabinet") }

  describe "POST /cart_items" do
    it "adds a product with a valid quantity" do
      expect do
        post cart_items_path, params: { product_id: product.id, quantity: 2 }
      end.to change(CartItem, :count).by(1)

      expect(response).to redirect_to(shipping_ledger_path)
      follow_redirect!
      expect(response.body).to include("was added to the basket")
    end

    it "rejects an invalid quantity instead of raising" do
      expect do
        post cart_items_path, params: { product_id: product.id, quantity: "abc" }
      end.not_to change(CartItem, :count)

      expect(response).to redirect_to(shipping_ledger_path)
      follow_redirect!
      expect(response.body).to include("Enter a valid quantity greater than 0.")
    end
  end

  describe "PATCH /cart_items/:id" do
    it "does not silently delete the line item on invalid input" do
      post cart_items_path, params: { product_id: product.id, quantity: 2 }
      cart_item = CartItem.order(:id).last

      expect do
        patch cart_item_path(cart_item), params: { quantity: "abc" }
      end.not_to change(CartItem, :count)

      expect(response).to redirect_to(shipping_ledger_path)
      expect(cart_item.reload.quantity).to eq(2)

      follow_redirect!
      expect(response.body).to include("Enter a valid quantity greater than 0.")
    end
  end
end
