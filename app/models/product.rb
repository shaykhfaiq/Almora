class Product < ApplicationRecord
  
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  has_many_attached : images

  
  has_many :variants, dependent: :destroy


  belongs_to :user

  
  has_many :product_option_types, dependent: :destroy
  has_many :option_types, through: :product_option_types
end
