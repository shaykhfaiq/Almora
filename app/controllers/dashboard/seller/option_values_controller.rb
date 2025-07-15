class Dashboard::Seller::OptionValuesController < ApplicationController
 
  layout "seller_layout"
  
  before_action :set_option_type

  def index
    @option_values = @option_type.option_values.order(:value)
    @option_value = OptionValue.new
  end

  def create
    @option_value = @option_type.option_values.new(option_value_params)

    if @option_value.save
      redirect_to dashboard_seller_option_type_option_values_path(@option_type), notice: "Option value added successfully."
    else
      @option_values = @option_type.option_values.order(:value)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @option_value = @option_type.option_values.find(params[:id])
    @option_value.destroy
    redirect_to dashboard_seller_option_type_option_values_path(@option_type), notice: "Option value deleted."
  end

  private

  def set_option_type
    @option_type = OptionType.find(params[:option_type_id])
  end

  def option_value_params
    params.require(:option_value).permit(:value)
  end
end
