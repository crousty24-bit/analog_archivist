class CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[update destroy]
  rescue_from ArgumentError, with: :handle_invalid_quantity

  def create
    product = Product.find(params[:product_id])
    current_cart.add_product(product, quantity_param)

    redirect_back fallback_location: shipping_ledger_path, notice: "#{product.title} was added to the basket."
  end

  def update
    quantity = quantity_param

    if quantity.nil?
      redirect_back fallback_location: shipping_ledger_path, alert: invalid_quantity_message
    elsif quantity.positive?
      @cart_item.update!(quantity: quantity)
      redirect_back fallback_location: shipping_ledger_path, notice: "Basket quantity updated."
    else
      @cart_item.destroy!
      redirect_back fallback_location: shipping_ledger_path, notice: "Item removed from the basket."
    end
  end

  def destroy
    @cart_item.destroy!
    redirect_back fallback_location: shipping_ledger_path, notice: "Item removed from the basket."
  end

  private

  def quantity_param
    Integer(params.fetch(:quantity, 1), exception: false)
  end

  def set_cart_item
    @cart_item = current_cart.cart_items.find(params[:id])
  end

  def handle_invalid_quantity
    redirect_back fallback_location: shipping_ledger_path, alert: invalid_quantity_message
  end

  def invalid_quantity_message
    "Enter a valid quantity greater than 0."
  end
end
