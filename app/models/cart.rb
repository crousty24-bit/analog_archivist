class Cart < ApplicationRecord
  belongs_to :user, optional: true

  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  before_validation :ensure_session_token, on: :create

  validates :session_token, presence: true, uniqueness: true
  validates :user_id, uniqueness: true, allow_nil: true

  def self.fetch_for(user:, session_token:)
    normalized_token = session_token.presence || SecureRandom.hex(16)

    if user
      guest_cart = find_by(session_token: normalized_token, user_id: nil)
      user_cart = user.cart

      if user_cart
        user_cart.merge!(guest_cart) if guest_cart.present? && guest_cart != user_cart
        return user_cart
      end

      return guest_cart.tap { |cart| cart.update!(user: user) } if guest_cart.present?

      return create!(user: user, session_token: normalized_token)
    end

    find_by(session_token: normalized_token, user_id: nil) || create!(session_token: normalized_token)
  end

  def add_product(product, quantity = 1)
    parsed_quantity = Integer(quantity, exception: false)
    raise ArgumentError, "quantity must be a positive integer" unless parsed_quantity&.positive?

    cart_item = cart_items.find_or_initialize_by(product: product)
    starting_quantity = cart_item.persisted? ? cart_item.quantity.to_i : 0
    cart_item.quantity = [ starting_quantity, 0 ].max + parsed_quantity
    cart_item.save!
    cart_item
  end

  def merge!(other_cart)
    return self if other_cart.blank? || other_cart == self

    transaction do
      other_cart.cart_items.includes(:product).find_each do |item|
        add_product(item.product, item.quantity)
      end

      other_cart.destroy!
    end

    self
  end

  def total_items
    cart_items.sum(:quantity)
  end

  def subtotal_cents
    cart_items.includes(:product).sum(&:line_total_cents)
  end

  def empty!
    cart_items.destroy_all
  end

  private

  def ensure_session_token
    self.session_token ||= SecureRandom.hex(16)
  end
end
