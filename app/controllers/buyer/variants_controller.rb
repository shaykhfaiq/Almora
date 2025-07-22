class Buyer::VariantsController < ApplicationController
  
  before_action:authenticate_user!
  
  def find_variant
    product = Product.find(params[:product_id])
    option_value_ids = params[:option_value_ids].map(&:to_i).sort
    variant = find_variant_for_product(product, option_value_ids)

    if variant
      render json: {
        success: true,
        variant: {
          id: variant.id,
          sku: variant.sku,
          price: variant.price,
          stock: variant.stock_quantity
        }
      }
    else
      render json: { success: false, message: "Variant not found" }, status: 404
    end
  end

  private

  def find_variant_for_product(product, option_value_ids)
    return nil if option_value_ids.blank?

    product.variants
      .joins(:option_values)
      .where(option_values: { id: option_value_ids })
      .group("variants.id")
      .having("COUNT(option_values.id) = ?", option_value_ids.length)
      .first
  end
end
