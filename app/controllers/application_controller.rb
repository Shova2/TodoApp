class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotUnique, with: :handle_record_not_unique

  private

  def user_not_authorized
    render json: { error: "You are not authorized to perform this action" }, status: :forbidden
  end

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end


  def handle_record_invalid(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_record_not_unique(exception)
    render json: { errors: ['Collaborator already exists'] }, status: :unprocessable_entity
  end


  # If CSRF protection causes issues, skip it for API requests
  skip_before_action :verify_authenticity_token, if: :devise_controller?
end
