class Dashboard::Seller::SellerDetailsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_seller!
  before_action :set_user_and_seller_detail

  layout "seller_layout"

  def show
  end

  def edit
  end

  def update

    puts "Updating Seeler"
    
    user_updated = @user.update(user_params)
    seller_updated = @seller_detail.update(seller_detail_params)

    if user_updated && seller_updated
      
      redirect_to dashboard_seller_seller_detail_path, notice: "Seller profile updated successfully."
    else
      
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user_and_seller_detail
    @user = current_user
    @seller_detail = current_user.seller_detail || current_user.build_seller_detail
  end

  def user_params
  params.require(:seller_detail).require(:user).permit(:full_name, :contact, :country, :city, :address, :display_picture)
  end


  def seller_detail_params
    params.require(:seller_detail).permit(:store_name, :store_url, :business_email, :ntn_number)
  end

  def authorize_seller!
    redirect_to root_path, alert: "Access denied: Sellers only." unless current_user.has_role?(:seller)
  end
end
