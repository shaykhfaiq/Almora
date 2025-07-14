class OptionValue < ApplicationRecord
  belongs_to :option_type

  has_many :variant_option_values, dependent: :destroy
  has_many :variants, through: :variant_option_values
end
