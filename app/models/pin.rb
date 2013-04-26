class Pin < ActiveRecord::Base
  attr_accessible :description, :price

  validates :description, presence: true
  validates :price, presence: true
  #rails validation
end
