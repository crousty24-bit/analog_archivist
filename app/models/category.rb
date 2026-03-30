class Category < ApplicationRecord
  has_many :products, -> { order(:sort_position, :title) }, dependent: :destroy

  validates :hero_label, :image_remote_url, :name, :slug, presence: true
  validates :slug, uniqueness: true

  scope :ordered, -> { order(:sort_position, :name) }
end
