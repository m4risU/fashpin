class Pin < ActiveRecord::Base
  extend FriendlyId
  friendly_id :description, use: :slugged
  attr_accessible :description, :price, :image, :image_remote_url, :product_url

  attr_accessor :product_url

  validates :description, presence: true
  validates :price, presence: true
  validates :user_id, presence: true
  validates_attachment :image, presence: true,
												content_type: { content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'] },
                       	size: { less_than: 5.megabytes }
  #rails validation

  belongs_to :user
  has_attached_file :image, :styles => { :medium => "320x240>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  def image_remote_url=(url_value)
    self.image = URI.parse(url_value) unless url_value.blank?
    super
  end
  
end

  
