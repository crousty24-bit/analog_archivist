class HomeController < ApplicationController
  FEATURED_PRODUCT_SLUG = "bally-74-resurrection".freeze
  HOME_CATEGORY_ORDER = %w[pinball trading-cards cat-trees oil-lamps].freeze
  RECENT_PRODUCT_ORDER = %w[
    aspen-cat-tower
    amber-victorian-sconce
    base-set-rare-foil
    zenith-transoceanic
  ].freeze

  def index
    @home_categories = categories_for(HOME_CATEGORY_ORDER)
    @featured_product = product_scope.find_by!(slug: FEATURED_PRODUCT_SLUG)
    @recent_products = products_for(RECENT_PRODUCT_ORDER)
  end

  private

  def product_scope
    Product.includes(:category, :product_images, :product_specifications)
  end

  def products_for(slugs)
    products = product_scope.where(slug: slugs).index_by(&:slug)
    slugs.filter_map { |slug| products[slug] }
  end

  def categories_for(slugs)
    categories = Category.ordered.where(slug: slugs).index_by(&:slug)
    slugs.filter_map { |slug| categories[slug] }
  end
end
