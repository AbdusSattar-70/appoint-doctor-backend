class Users::SessionsController < Devise::SessionsController
  respond_to :json

  protected

  def respond_with(_resource, options = {})
    message = options[:message] || 'Successfully Signed In'
    status_code = options[:status_code] || :ok

    render json: {
      status: {
        code: Rack::Utils.status_code(status_code),
        message:,
        data: current_user
      }
    }, status: status_code
  end

  def respond_to_on_destroy
    jwt_token = request.headers['Authorization']&.split(' ')&.last

    if jwt_token
      jwt_payload = JWT.decode(jwt_token, Rails.application.credentials.fetch(:secret_key_base)).first
      user_id = jwt_payload['sub']
      current_user = User.find_by(id: user_id)

      if current_user
        sign_out(current_user)
        render json: {
          status: {
            code: 200, message: 'User Signed Out Successfully!'
          }
        }
      else
        render json: {
          status: {
            code: 401, message: 'Cannot find user active session'
          }
        }, status: :unauthorized
      end
    else
      render json: {
        status: {
          code: 401, message: 'Unauthorized: Missing JWT token'
        }
      }, status: :unauthorized
    end
  rescue JWT::DecodeError => e
    render json: {
      status: {
        code: 401, message: 'Unauthorized: Invalid JWT token'
      }
    }, status: :unauthorized
  end
end
