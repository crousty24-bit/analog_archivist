require "test_helper"

class ProductTest < ActiveSupport::TestCase
  setup do
    @category = Category.create!(
      slug: "pinball",
      name: "Pinball",
      hero_label: "Mechanical Curiosities",
      image_remote_url: "https://example.com/category.jpg"
    )
  end

  test "slug must be unique" do
    Product.create!(category: @category, slug: "solaris", title: "Solaris", price_cents: 1000)

    duplicate = Product.new(category: @category, slug: "solaris", title: "Duplicate", price_cents: 2000)

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:slug], "has already been taken"
  end

  test "image fallbacks remain stable when only a card image exists" do
    product = Product.create!(category: @category, slug: "cosmic-voyager", title: "Cosmic Voyager", price_cents: 2500)
    image = product.product_images.create!(role: "card", remote_url: "https://example.com/card.jpg")

    assert_equal image, product.card_image
    assert_equal image, product.hero_image
    assert_equal image, product.story_image
  end
end
