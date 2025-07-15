class Dashboard::Seller::CategoriesController < ApplicationController
  layout "seller_layout"

  before_action :set_category, only: [:edit, :update]

  def index
    @categories = current_user.categories
  end

  def new
    @category = Category.new
  end

  def create
    @category = current_user.categories.build(category_params)
    
    if @category.save
      redirect_to dashboard_seller_categories_path, notice: "Category created successfully"
    else
      flash.now[:alert] = "Failed to create category"
      render :new
    end
  end

  def edit
    
  end

  def update
    if @category.update(category_params)
      redirect_to dashboard_seller_categories_path, notice: "Category updated successfully"
    else
      flash.now[:alert] = "Failed to update category"
      render :edit
    end
  end

  def destroy
    @category=current_user.categories.find(params[:id])
    if @category.destroy
      redirect_to dashboard_seller_categories_path,notice:"Category deleted successfully"
    else
      redirect_to dashboard_seller_categories_path, alert: "Failed"
    end
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
