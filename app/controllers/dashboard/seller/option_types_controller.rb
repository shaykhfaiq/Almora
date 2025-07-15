module Dashboard
  module Seller
    class OptionTypesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_option_type, only: [:edit, :update, :destroy]

      layout "seller_layout"

      def index
        @option_types = OptionType.all
        @option_type = OptionType.new
      end

     def create
      @option_type = OptionType.new(option_type_params)
       if @option_type.save
         redirect_to dashboard_seller_option_type_option_values_path(@option_type), notice: "Option type created successfully"
      else
         @option_types = OptionType.all
         render :index, status: :unprocessable_entity
     end
    end

      def edit; end

      def update
        if @option_type.update(option_type_params)
          redirect_to dashboard_seller_option_types_path, notice: "Option type updated"
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @option_type.destroy
        redirect_to dashboard_seller_option_types_path, notice: "Option type deleted successfully"
      end

      private

      def set_option_type
        @option_type = OptionType.find(params[:id])
      end

      def option_type_params
        params.require(:option_type).permit(:name)
      end
    end
  end
end
