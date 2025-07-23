module Buyer
  class CartItemsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_cart

  def create
  product = Product.find(params[:product_id])
  option_value_ids = params[:options]&.values&.map(&:to_i)&.sort

  variant = find_variant_for_product(product, option_value_ids)

  unless variant
    respond_to do |format|
      format.html { redirect_to request.referer, alert: "Selected options are invalid." }
      format.json { render json: { error: "Invalid variant" }, status: :unprocessable_entity }
    end
    return
  end

  quantity_to_add = params[:quantity].to_i
  quantity_to_add = 1 if quantity_to_add < 1

  item = @cart.cart_items.find_or_initialize_by(variant_id: variant.id)

  if item.persisted?
    item.quantity += quantity_to_add
  else
    item.quantity = quantity_to_add
    item.unit_price = product.base_price
   
  end

  item.save!

  respond_to do |format|
    format.html do
      if params[:buy_now] == "true"
        redirect_to buyer_checkout_path, notice: "Proceed to checkout"
      else
        redirect_to buyer_cart_path, notice: "Product added to cart"
      end
    end
    format.json { render json: { message: "Product added to cart", item_id: item.id }, status: :ok }
  end
end


    private

    def set_cart
      @cart = current_user.cart || current_user.create_cart
    end

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
end
