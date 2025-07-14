class Dashboard::Seller::CategoriesController < ApplicationController

    layout "seller_layout"


    def create
        @category=Category.new(cateegory_params)
        if @categrory.save
            redirect_to dashboard_seller_categories_path, notice:"Category Created successfully"
        else
            render :new
        end

    end

end
