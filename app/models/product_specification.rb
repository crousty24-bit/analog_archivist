class ProductSpecification < ApplicationRecord
  belongs_to :product

  validates :label, :value, presence: true
end
