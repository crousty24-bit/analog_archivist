class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product, optional: true

  validates :line_total_cents, :quantity, :title, :unit_price_cents, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :line_total_cents, :unit_price_cents, numericality: { greater_than_or_equal_to: 0 }
end
