class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  # If CSRF protection causes issues, skip it for API requests
  skip_before_action :verify_authenticity_token, if: :devise_controller?
end

# class ApplicationController < ActionController::API
#         include DeviseTokenAuth::Concerns::SetUserByToken
#   # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
#   # allow_browser versions: :modern
# end
