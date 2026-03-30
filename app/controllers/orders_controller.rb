class OrdersController < ApplicationController
  before_action :require_checkout_login

  def create
    if current_cart.cart_items.empty?
      redirect_to shipping_ledger_path, alert: "Your basket is empty."
      return
    end

    @order = current_user.orders.build(order_params)
    @order.populate_from_cart!(current_cart)

    if @order.save
      current_cart.empty!
      redirect_to shipping_ledger_path, notice: "Manifest sealed. Your archival order has been recorded."
    else
      render "shipping_ledgers/show", status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :billing_matches_shipping,
      :city_province,
      :email,
      :full_name,
      :postal_code,
      :shipping_method,
      :street_address
    )
  end

  def require_checkout_login
    return if user_signed_in?

    store_location_for(:user, shipping_ledger_path)
    redirect_to new_user_session_path, alert: "Sign in to finalize the shipping ledger."
  end
end
