class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_current_context

  helper_method :cart_count, :current_cart

  private

  def cart_count
    current_cart.total_items
  end

  def current_cart
    @current_cart ||= begin
      session[:cart_token] ||= SecureRandom.hex(16)
      cart = Cart.fetch_for(user: current_user, session_token: session[:cart_token])
      session[:cart_token] = cart.session_token
      cart
    end
  end

  def set_current_context
    Current.user = current_user
    Current.cart = current_cart
  end
end
