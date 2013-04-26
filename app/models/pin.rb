class Pin < ActiveRecord::Base
  attr_accessible :description, :price

  validates :description, presence: true
  validates :price, presence: true
  #rails validation

  belongs_to :user
  validates :user_id, presence: true
end
