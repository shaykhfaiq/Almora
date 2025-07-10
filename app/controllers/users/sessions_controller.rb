class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if resource.has_role?(:seller)
      dashboard_seller_road_path
    elsif resource.has_role?(:buyer)
      root_path
    else
      super
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end


