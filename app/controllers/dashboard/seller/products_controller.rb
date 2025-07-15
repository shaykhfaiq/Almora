class Dashboard::Seller::ProductsController < ApplicationController
  layout "seller_layout"
  before_action :authenticate_user!
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = current_user.products.includes(:variants, :category, images_attachments: :blob)
    @option_types = OptionType.all
    @option_values = OptionValue.all
  end

  def filter
    @products = filtered_products_by_options
    @option_types = OptionType.all
    @option_values = OptionValue.all
    render :index
  end

  def show
    @variants = @product.variants.includes(:option_values)
  end

  def new
    @product = current_user.products.build
    @categories = current_user.categories
  end

  def create
    @product = current_user.products.build(product_params)

    if @product.save
      redirect_to new_dashboard_seller_product_variant_path(@product), notice: 'Product was successfully created.'
    else
      @categories = current_user.categories
      render :new
    end
  end

  def edit
    @categories = current_user.categories
  end

  def update
    if @product.update(product_params)
      redirect_to dashboard_seller_product_path(@product), notice: 'Product was successfully updated.'
    else
      @categories = current_user.categories
      render :edit
    end
  end

  def destroy
    if @product.destroy
      redirect_to dashboard_seller_products_path, notice: 'Product deleted successfully.'
    else
      redirect_to dashboard_seller_products_path, alert: 'Failed to delete product.'
    end
  end

  private

  def set_product
    @product = current_user.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name, :description, :base_price, :category_id,
      images: []
    )
  end

  def filtered_products_by_options
    products = current_user.products

    if params[:option_type_id].present? && params[:option_value_id].present?
      products = products.joins(variants: { variant_option_values: { option_value: :option_type } })
                         .where(option_values: { id: params[:option_value_id], option_type_id: params[:option_type_id] })
    elsif params[:option_value_id].present?
      products = products.joins(variants: { variant_option_values: :option_value })
                         .where(option_values: { id: params[:option_value_id] })
    elsif params[:option_type_id].present?
      products = products.joins(variants: { variant_option_values: { option_value: :option_type } })
                         .where(option_types: { id: params[:option_type_id] })
    end

    products.distinct
  end
end
