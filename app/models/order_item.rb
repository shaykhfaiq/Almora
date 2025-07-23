class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product 
  belongs_to :variant, optional: true
end
