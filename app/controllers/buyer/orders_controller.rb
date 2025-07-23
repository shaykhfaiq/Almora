class Buyer::OrdersController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = current_user

    unless user_has_address_info?
      flash.now[:alert] = "Please complete your address to place an order."
      return render :complete_address_form
    end
  end

  def create
    unless user_has_address_info?
      flash[:alert] = "Missing address information."
      return redirect_to new_buyer_order_path
    end

    cart = JSON.parse(params[:cart_json] || "[]")
    if cart.empty?
      redirect_to root_path, alert: "Cart is empty."
      return
    end

    sub_total = cart.sum { |item| item["unit_price"].to_i * item["quantity"].to_i }
    shipping_fee = 200
    total = sub_total + shipping_fee

    ActiveRecord::Base.transaction do
      order = current_user.orders.create!(
        status: "pending",
        sub_total: sub_total,
        shipping_fee: shipping_fee,
        total: total,
        payment_method: "Cash on Delivery",
        payment_status: "Pending",
        shipping_address: full_user_address,
        placed_at: Time.current
      )

      cart.each do |item|
        variant = Variant.find(item["variant_id"])
        product = variant.product

        if variant.stock_quantity < item["quantity"].to_i
          raise "Not enough stock for #{product.name} (#{variant.option_values.map(&:value).join(', ')})"
        end

        OrderItem.create!(
          order: order,
          product: product,
          variant: variant,
          product_name: product.name,
          variant_description: variant.option_values.map(&:value).join(", "),
          unit_price: item["unit_price"],
          quantity: item["quantity"],
          total_price: item["unit_price"].to_i * item["quantity"].to_i
        )

        variant.update!(stock_quantity: variant.stock_quantity - item["quantity"].to_i)
      end
    end

    render :success
  rescue => e
    redirect_to new_buyer_order_path, alert: "Order failed: #{e.message}"
  end

  def update_address
    current_user.update!(address_params)
    redirect_to new_buyer_order_path, notice: "Address updated. You can now place your order."
  end

  private

  def user_has_address_info?
    user = current_user
    user.contact.present? && user.city.present? && user.country.present? && user.address.present?
  end

  def full_user_address
    u = current_user
    "#{u.address}, #{u.city}, #{u.country}"
  end

  def address_params
    params.require(:user).permit(:contact, :address, :city, :country)
  end
end
