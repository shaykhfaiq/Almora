class Variant < ApplicationRecord
  belongs_to :product, dependent: :destroy

  has_many :variant_option_values, dependent: :destroy
  has_many :option_values, through: :variant_option_values
end
