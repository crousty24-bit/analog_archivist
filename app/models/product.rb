class Product < ApplicationRecord
  belongs_to :category

  has_many :product_images, -> { order(:position, :id) }, dependent: :destroy
  has_many :product_specifications, -> { order(:position, :id) }, dependent: :destroy

  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
  validates :slug, :title, presence: true
  validates :slug, uniqueness: true
  validates :sku, uniqueness: true, allow_blank: true

  scope :ordered, -> { order(:sort_position, :title) }

  def card_image
    image_for("card") || image_for("hero") || first_gallery_image
  end

  def hero_image
    image_for("hero") || image_for("card") || first_gallery_image
  end

  def story_image
    image_for("story") || first_gallery_image || image_for("hero") || image_for("card")
  end

  def gallery_images
    product_images.select(&:gallery?)
  end

  def primary_identity_value
    material.presence || subtitle.presence || category.name
  end

  def primary_identity_label
    material.present? ? "Primary Material" : "Record Note"
  end

  def detail_body_for_display
    detail_body.presence || short_description.presence
  end

  def detail_quote_for_display
    detail_quote.presence
  end

  def story_title_for_display
    story_title.presence
  end

  def story_body_for_display
    story_body.presence
  end

  def catalog_meta
    [ category.name, archive_number.presence ].compact.join(" • Archive ")
  end

  def to_param
    slug
  end

  private

  def first_gallery_image
    gallery_images.first
  end

  def image_for(role)
    product_images.find { |image| image.role == role }
  end
end
