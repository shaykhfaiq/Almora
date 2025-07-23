module Dashboard
  module Seller
    class OrdersController < ApplicationController
      layout "seller_layout"
      before_action :authenticate_user!
      before_action :authorize_seller!

      def index
       
        @orders = Order.joins(order_items: :product)
                       .where(products: { user_id: current_user.id })
                       .distinct
      end

      def show
        @order = Order.find(params[:id])

       
        @seller_order_items = @order.order_items
                                    .joins(:product)
                                    .where(products: { user_id: current_user.id })
                                    .includes(:variant, :product)

        @buyer = @order.user

        
        @seller_total = @seller_order_items.sum do |item|
          item.variant.price.to_i * item.quantity.to_i
        end
      end

      private

      def authorize_seller!
        unless current_user.has_role?(:seller)
          redirect_to root_path, alert: "You are not authorized to access this section."
        end
      end
    end
  end
end
