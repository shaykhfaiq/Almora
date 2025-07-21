module Buyer
  class CartsController < ApplicationController
    before_action :authenticate_user!

    def show
      @cart = current_user.cart
    end

    def destroy
      cart = current_user.cart
      cart.cart_items.destroy_all if cart
      redirect_to buyer_cart_path, notice: "Cart emptied"
    end
  end
end
