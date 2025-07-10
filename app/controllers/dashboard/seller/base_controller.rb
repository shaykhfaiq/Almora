class Dashboard::Seller::BaseController<ApplicationController
    before_action:authenticate_user!
    before_action:authorize_seller!

    private
    def authorize_seller!
        unless current_user.has_role?(:seller)
            redirect_to root_path, alert: "You are not authorized to access this section."
        end
    end

end