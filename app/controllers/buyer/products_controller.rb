class Buyer::ProductsController < ApplicationController
    

    layout "buyer_layout"
    def show
    @product = Product.find(params[:id])
    @variants = @product.variants.includes(:option_values)
    @option_types = @product.option_types.includes(:option_values)
    @default_variant = @variants.first
    end



end