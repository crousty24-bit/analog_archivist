class Order < ApplicationRecord
  DEFAULT_SHIPPING_METHOD = "overland_carriage"
  SHIPPING_OPTIONS = {
    "overland_carriage" => {
      label: "Overland Carriage",
      description: "Estimated arrival in 5-7 business days",
      amount_cents: 1400
    },
    "pony_express_premium" => {
      label: "Pony Express Premium",
      description: "Estimated arrival in 2 business days",
      amount_cents: 3850
    }
  }.freeze
  STATUSES = %w[submitted].freeze

  belongs_to :user

  has_many :order_items, dependent: :destroy

  before_validation :normalize_email
  before_validation :assign_manifest_number, on: :create
  before_validation :apply_shipping_amount

  validates :city_province, :email, :full_name, :manifest_number, :postal_code, :shipping_method,
            :status, :street_address, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :manifest_number, uniqueness: true
  validates :shipping_method, inclusion: { in: SHIPPING_OPTIONS.keys }
  validates :status, inclusion: { in: STATUSES }

  def self.shipping_options
    SHIPPING_OPTIONS
  end

  def self.tax_amount_for(subtotal_cents)
    (subtotal_cents.to_i * 0.08).round
  end

  def populate_from_cart!(cart)
    selected_shipping_method = shipping_method.presence || DEFAULT_SHIPPING_METHOD
    selected_option = SHIPPING_OPTIONS[selected_shipping_method]

    if selected_option
      self.shipping_method = selected_shipping_method
      self.shipping_amount_cents = selected_option[:amount_cents]
    end

    self.subtotal_cents = cart.subtotal_cents
    self.tax_amount_cents = self.class.tax_amount_for(subtotal_cents)
    self.total_cents = subtotal_cents + shipping_amount_cents + tax_amount_cents

    order_items.clear

    cart.cart_items.includes(:product).each do |item|
      order_items.build(
        product: item.product,
        title: item.product.title,
        sku: item.product.sku,
        archive_number: item.product.archive_number,
        unit_price_cents: item.product.price_cents,
        quantity: item.quantity,
        line_total_cents: item.line_total_cents
      )
    end
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def assign_manifest_number
    return if manifest_number.present?

    sequence = (Order.maximum(:id) || 0) + 1
    self.manifest_number = format("1924-AC-%03d", sequence)
  end

  def apply_shipping_amount
    self.status ||= "submitted"
    self.shipping_method = DEFAULT_SHIPPING_METHOD if shipping_method.blank?

    option = SHIPPING_OPTIONS[shipping_method]
    return unless option

    self.shipping_amount_cents = option[:amount_cents]
  end
end
