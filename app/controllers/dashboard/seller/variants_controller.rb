class Dashboard::Seller::VariantsController < ApplicationController
  layout "seller_layout"
  before_action :authenticate_user!
  before_action :set_product, except: [:all_index]
  before_action :set_variant, only: [:update, :destroy]

  def index
    @variants = @product.variants.includes(:option_values)
    @products = current_user.products.includes(variants: :option_values)
  end

  def new
    @variant = @product.variants.new
    @option_types = @product.option_types.includes(:option_values)
  end

  def create
    if params[:option_value_ids].present?
      handle_combination_creation
    else
      handle_single_variant_creation
    end
  end

  def show
    @product = current_user.products.find(params[:id])
    @variants = @product.variants.includes(:option_values)
  end

  def update
    if @variant.update(variant_params)
      redirect_to dashboard_seller_product_variants_path(@product), notice: "Variant updated successfully."
    else
      redirect_to dashboard_seller_product_variants_path(@product), alert: "Failed to update variant."
    end
  end

  def destroy
    @variant.destroy
    redirect_to dashboard_seller_product_path(@product), notice: "Variant deleted."
  end

  def all_index
    @products = current_user.products.includes(variants: [:option_values])
  end

  private

  def handle_combination_creation
    sets = extract_option_value_sets

    if sets.empty?
      redirect_to dashboard_seller_product_path(@product), alert: "Please select at least one option value."
      return
    end

    combinations = generate_combinations(sets)
    created_count = create_variants(combinations)

    redirect_to dashboard_seller_product_variants_path, notice: "#{created_count} new variant(s) generated."
  end

  def handle_single_variant_creation
    @variant = @product.variants.new(variant_params)
    @variant.option_value_ids = extract_option_value_sets.flatten if params[:option_value_ids]

    if @variant.save
      redirect_to dashboard_seller_product_variants_path, notice: "Variant created successfully."
    else
      @option_types = @product.option_types.includes(:option_values)
      render :new
    end
  end

  def extract_option_value_sets
    raw = params[:option_value_ids] || {}
    raw.values.map do |vals|
      Array(vals).reject(&:blank?).map(&:to_i)
    end
  end

  def generate_combinations(value_sets)
    return [] if value_sets.empty?

    first = value_sets.shift
    first.product(*value_sets)
  end

  def create_variants(combinations)
    count = 0

    combinations.each do |value_ids|
      sorted_ids = value_ids.map(&:to_i).sort
      unless variant_already_exists?(sorted_ids)
        @product.variants.create(
          sku: generate_sku(sorted_ids),
          price: @product.base_price,
          stock_quantity: 10,
          option_value_ids: sorted_ids
        )
        count += 1
      end
    end

    count
  end

  def variant_already_exists?(option_value_ids)
    existing_variants = @product.variants.includes(:option_values)

    existing_variants.any? do |variant|
      variant.option_value_ids.sort == option_value_ids
    end
  end

  def generate_sku(option_value_ids)
    values = OptionValue.where(id: option_value_ids).order(:id).pluck(:value)
    "SKU-#{Time.now.to_i}-#{values.join('-').parameterize.upcase}"
  end

  def set_product
    @product = if params[:product_id].present?
      current_user.products.find_by(id: params[:product_id])
    elsif params[:id].present? && action_name == "show"
      current_user.products.find_by(id: params[:id])
    end

    redirect_to dashboard_seller_products_path, alert: "Product not found." unless @product
  end

  def set_variant
    @variant = @product.variants.find_by(id: params[:id])
    redirect_to dashboard_seller_product_path(@product), alert: "Variant not found." unless @variant
  end

  def variant_params
    params.require(:variant).permit(:sku, :price, :stock_quantity)
  end
end
