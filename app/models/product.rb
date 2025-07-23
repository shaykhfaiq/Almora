class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category,  dependent: :destroy

  has_many_attached :images

  has_many :variants, dependent: :destroy

  has_many :product_option_types, dependent: :destroy
  has_many :option_types, through: :product_option_types
end
