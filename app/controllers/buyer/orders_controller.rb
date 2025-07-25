class Buyer::OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
   
  end

  def create
    cart_items = JSON.parse(params[:cart_json] || "[]")
    if cart_items.empty?
      redirect_to buyer_cart_path, alert: "Your cart is empty." and return
    end

    
    if current_user.contact.blank? || current_user.address.blank? || current_user.city.blank? || current_user.country.blank?
      redirect_to buyer_orders_update_address_path, alert: "Please complete your contact and address information first." and return
    end

    
    subtotal = cart_items.sum do |item|
      variant = Variant.find(item["variant_id"])
      variant.price.to_i * item["quantity"].to_i
    end

    shipping_fee = 200
    total_amount = subtotal + shipping_fee

    ActiveRecord::Base.transaction do
     
      order = Order.create!(
        user: current_user,
        sub_total: subtotal,
        shipping_fee: shipping_fee,
        total: total_amount,
        payment_method: params[:payment_method],
        payment_status: params[:payment_method] == "Stripe" ? "paid" : "unpaid",
        status: "In Processing",
        shipping_address: current_user.address,
        placed_at: Time.current
      )

      
      cart_items.each do |item|
        variant = Variant.find(item["variant_id"])
        product = variant.product

        quantity = item["quantity"].to_i
        unit_price = variant.price.to_i
        total_price = unit_price * quantity

        OrderItem.create!(
          order: order,
          product: product,
          variant: variant,
          quantity: quantity,
          unit_price: unit_price,
          total_price: total_price,
          product_name: product.name,
          variant_description: variant.option_values.map(&:value).join(", ")
        )

        variant.update!(stock_quantity: variant.stock_quantity - quantity)
      end

    
      if params[:payment_method] == "Stripe"
        session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          line_items: cart_items.map do |item|
            variant = Variant.find(item["variant_id"])
            product = variant.product

            {
              price_data: {
                currency: 'usd',
                unit_amount: variant.price.to_i * 100,
                product_data: {
                  name: "#{product.name} (#{variant.option_values.map(&:value).join(', ')})"
                }
              },
              quantity: item["quantity"].to_i
            }
          end,
          mode: 'payment',
          success_url: buyer_orders_success_url(order_id: order.id),
          cancel_url: buyer_cart_url
        )

        redirect_to session.url, allow_other_host: true and return
      else
        redirect_to buyer_orders_success_path(order_id: order.id) and return
      end
    rescue => e
      redirect_to buyer_cart_path, alert: "Order failed: #{e.message}"
    end
  end

  def success
    @order = Order.find_by(id: params[:order_id], user: current_user)
    redirect_to root_path, alert: "Order not found." unless @order
  end

  def edit_address
    @user = current_user
  end

  def update_address
    if current_user.update(user_params)
      redirect_to buyer_cart_path, notice: "Address updated. You can now place your order."
    else
      flash.now[:alert] = "Please correct the errors below."
      render :edit_address
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :contact, :address, :city, :country)
  end
end
