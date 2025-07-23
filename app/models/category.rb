class Category < ApplicationRecord
  has_many :categorizations, dependent: :destroy
  has_many :products,        dependent: :destroy
  belongs_to :user
end
