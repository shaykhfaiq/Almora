class Buyer::VariantsController < ApplicationController
  def find_variant
    product = Product.find(params[:product_id])
    option_value_ids = params[:option_value_ids].map(&:to_i).sort

    variant = product.variants.detect do |v|
      v.option_values.pluck(:id).sort == option_value_ids
    end

    if variant
      render json: {
        variant_id: variant.id,
        price: ActionController::Base.helpers.number_to_currency(variant.price)
      }
    else
      render json: { variant_id: nil, price: "N/A" }
    end
  end
end
