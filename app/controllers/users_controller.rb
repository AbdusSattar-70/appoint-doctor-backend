class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i{create destroy}
  before_action :authorize_super_admin_or_admin, only: %i[create destroy]

  # GET /users
  def index
    role = params[:role]

    @users = case role
             when 'doctor'
               User.doctors
             when 'patient'
               User.patients
             when 'admin'
               User.admin_users
             else
               # If the role is not specified or invalid, fetch all users
               User.all
             end

    render json: @users
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  # GET /users/doctors/:id
  def show_doctor
    @user = User.doctors.find_by(id: params[:id])
    if @user.nil?
      render json: { error: 'Doctor not found' }, status: :not_found
    else
      @appointments = @user.appointments
      render json: { user: @user, appointments: @appointments }
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find_by(id: params[:id])

    if @user.nil?
      render json: { message: 'Not Found', data: { code: 401 } }, status: :not_found
    else
      begin
        @user.destroy
        head :no_content
      rescue ActiveRecord::InvalidForeignKey
        referenced_records = find_referenced_records(@user)
        render json: { message: 'Cannot delete the user', references: referenced_records,
                       data: { code: 402 } }, status: :unprocessable_entity
      rescue StandardError
        render json: { message: 'An error occurred while processing the request.', data: { code: 403 } },
               status: :internal_server_error
      end
    end
  end

  private

  def find_referenced_records(user)
    referenced_records = []
    appointments = user.appointments
    referenced_records << appointments if appointments.any?
    referenced_records
  end

  def authorize_super_admin_or_admin
     return if current_user.super_admin? || current_user.admin?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
