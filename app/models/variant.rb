class Variant < ApplicationRecord
  belongs_to :product, dependent: :destroy

  has_many :variant_option_values, dependent: :destroy
  has_many :option_values, through: :variant_option_values


  def full_name
  option_values.map { |v| "#{v.option_type.name}: #{v.value}" }.join(", ")
end

end
