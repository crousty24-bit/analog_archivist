class ProductsController < ApplicationController
  CATALOG_PRODUCT_ORDER = %w[
    victorian-feline-tower
    cosmic-voyager-1974
    gilded-monarch-set
    admirals-beacon
    palace-chaise
    cerulean-glass-lanterns
  ].freeze
  VALID_SORTS = %w[featured price-asc price-desc title].freeze

  def index
    @selected_category = Category.find_by(slug: params[:category])
    @sort = params[:sort].presence_in(VALID_SORTS) || "featured"
    @products = filtered_products
  end

  def show
    @product = product_scope.find_by!(slug: params[:slug])
  end

  private

  def filtered_products
    scope = product_scope.where(slug: CATALOG_PRODUCT_ORDER)
    scope = scope.where(category: @selected_category) if @selected_category.present?

    case @sort
    when "price-asc"
      scope.order(:price_cents, :sort_position, :title)
    when "price-desc"
      scope.order(price_cents: :desc, sort_position: :asc, title: :asc)
    when "title"
      scope.order(:title)
    else
      scope.ordered
    end
  end

  def product_scope
    Product.includes(:category, :product_images, :product_specifications)
  end
end
