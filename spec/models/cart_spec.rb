require "rails_helper"

RSpec.describe Cart, type: :model do
  let(:category) do
    Category.create!(
      slug: "cat-trees",
      name: "Cat Trees",
      hero_label: "Cat Trees",
      image_remote_url: "https://example.com/category.jpg"
    )
  end

  let(:product) do
    Product.create!(
      category: category,
      slug: "archival-spire",
      title: "Archival Spire",
      price_cents: 12_500
    )
  end

  describe "#add_product" do
    it "increments an existing line item" do
      cart = described_class.create!(session_token: "guest-token")

      cart.add_product(product, 1)
      cart.add_product(product, 2)

      expect(cart.cart_items.find_by!(product: product).quantity).to eq(3)
    end

    it "rejects non-positive quantities" do
      cart = described_class.create!(session_token: "guest-token")

      expect { cart.add_product(product, 0) }
        .to raise_error(ArgumentError, "quantity must be a positive integer")

      expect(cart.cart_items).to be_empty
    end
  end
end
