class ShippingLedgersController < ApplicationController
  def show
    @order = current_user&.orders&.build(email: current_user.email) || Order.new
    @order.shipping_method ||= Order::DEFAULT_SHIPPING_METHOD
    @order.billing_matches_shipping = true if @order.billing_matches_shipping.nil?
  end
end
