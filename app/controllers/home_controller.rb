class HomeController < ApplicationController
  
  layout "buyer_layout"
  def index
    @categories = Category.all
    @products = Product.includes(:images_attachments).order(created_at: :desc)
  end


end
