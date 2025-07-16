class Dashboard::Seller::VariantsController < ApplicationController
  layout "seller_layout"
  before_action :authenticate_user!
  before_action :set_product, except: [:all_index]
  before_action :set_variant, only: [:destroy]

  def index
    @variants = @product.variants.includes(:option_values)
    @products = current_user.products.includes(variants: :option_values)
  end

  def new
    @variant = @product.variants.new
    @option_types = @product.option_types.includes(:option_values)
  end

  def create
    @variant = @product.variants.new(variant_params)
    @variant.option_value_ids = params[:option_value_ids].values.reject(&:blank?) if params[:option_value_ids]

    if @variant.save
      redirect_to dashboard_seller_product_variants_path(@product), notice: 'Variant created.'
    else
      @option_types = @product.option_types.includes(:option_values)
      render :new
    end
  end

  def destroy
    @variant.destroy
    redirect_to dashboard_seller_product_variants_path(@product), notice: 'Variant deleted.'
  end

  def all_index
    @products = current_user.products.includes(variants: [:option_values])
  end

  private

  def set_product
    if params[:product_id].present?
      @product = current_user.products.find_by(id: params[:product_id])
      unless @product
        redirect_to dashboard_seller_products_path, alert: "Product not found." and return
      end
    else
      redirect_to dashboard_seller_products_path, alert: "Missing product context." and return
    end
  end

  def set_variant
    @variant = @product.variants.find_by(id: params[:id])
    unless @variant
      redirect_to dashboard_seller_product_variants_path(@product), alert: "Variant not found." and return
    end
  end

  def variant_params
    params.require(:variant).permit(:sku, :price, :stock_quantity)
  end
end
