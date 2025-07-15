module Dashboard
  module Seller
    class ProductOptionTypesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_product

      layout "seller_layout"

      def create
        @option_type = OptionType.find(params[:option_type_id])
        unless @product.option_types.include?(@option_type)
          @product.option_types << @option_type
          redirect_to dashboard_seller_product_variants_path(@option_type) , notice: 'Option type added.'
        else
          redirect_to dashboard_seller_product_variants_path(@option_type), alert: 'Option type already assigned.'
        end
      end

      def destroy
        product_option_type = @product.product_option_types.find_by(option_type_id: params[:id])
        if product_option_type
          product_option_type.destroy
          redirect_to dashboard_seller_product_path(@product), notice: 'Option type removed.'
        else
          redirect_to dashboard_seller_product_path(@product), alert: 'Option type not found.'
        end
      end

      private

      def set_product
        @product = current_user.products.find(params[:product_id])
      end
    end
  end
end