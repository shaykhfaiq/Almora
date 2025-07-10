class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def create
    super do |resource|
      if params[:user][:first_name] && params[:user][:last_name]
        resource.full_name = "#{params[:user][:first_name]} #{params[:user][:last_name]}"
        resource.save
      end

      
      if params[:user][:role].present?
        resource.add_role(params[:user][:role].to_sym)
      end
    end
  end

  protected

  def after_sign_up_path_for(resource)
    resource.has_role?(:seller) ? dashboard_seller_root_path : root_path
  end

  def configure_permitted_parameters
   
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end
end
