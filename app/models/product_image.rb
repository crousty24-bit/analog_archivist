class ProductImage < ApplicationRecord
  ROLES = %w[card hero story gallery].freeze

  belongs_to :product

  validates :remote_url, :role, presence: true
  validates :role, inclusion: { in: ROLES }

  def gallery?
    role == "gallery"
  end
end
