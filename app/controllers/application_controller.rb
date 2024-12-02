class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { error: "You are not authorized to perform this action" }, status: :forbidden
  end
  # If CSRF protection causes issues, skip it for API requests
  skip_before_action :verify_authenticity_token, if: :devise_controller?
end
