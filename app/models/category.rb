class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :products
  belongs_to :user
end
