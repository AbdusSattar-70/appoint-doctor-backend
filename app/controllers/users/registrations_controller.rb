class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params
  respond_to :json

  # POST /users
  def create
    if params[:user][:role] == 'doctor'
      create_doctor
    else
      @user = User.new(regular_user_params)

      if @user.save
        render json: {
          status: {
            code: 200,
            message: 'User Created Successfully!',
            data: @user
          }
        }, status: :ok
      else
        render json: {
          status: {
            code: 422,
            message: 'Unable to Create User',
            errors: @user.errors.full_messages
          }
        }, status: :unprocessable_entity
      end
    end
  end

  private

  def create_doctor
    @user = User.new(doctor_params)

    if @user.save
      render json: {
        status: {
          code: 200,
          message: 'Doctor Created Successfully!',
          data: @user
        }
      }, status: :ok
    else
      render json: {
        status: {
          code: 422,
          message: 'Unable to Create Doctor',
          errors: @user.errors.full_messages
        }
      }, status: :unprocessable_entity
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: [
                                        :name, :age, :email, :photo, :role,
                                        :password, :password_confirmation,
                                        { address: %i[street city state zip_code] }
                                      ])
  end

  def doctor_params
    params.require(:user).permit(
      :name, :age, :email, :photo, :role, :password, :password_confirmation,
      :qualification, :description, :experiences,
      :available_from, :available_to, :consultation_fee,
      :rating, :specialization,
      address: %i[street city state zip_code]
    )
  end

  def regular_user_params
    params.require(:user).permit(
      :name, :age, :email, :photo, :role, :password, :password_confirmation,
      address: %i[street city state zip_code]
    )
  end
end
