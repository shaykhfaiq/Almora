class Buyer::CategoriesController < ApplicationController
    layout "buyer_layout"

    def show
    @category = Category.find(params[:id])
    @products = @category.products.includes(:images_attachments)
  end
end