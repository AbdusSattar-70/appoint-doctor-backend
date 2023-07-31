class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[destroy]
  before_action :authorize_super_admin_or_admin, only: %i[create destroy]

  # GET /users
  def index
    role = params[:role]

    @users = if role == 'doctor'
               User.doctors
             elsif role == 'patient'
               User.patients
             elsif role == 'admin'
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

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    head :no_content
  end

  private

  def authorize_super_admin_or_admin
    return if current_user.super_admin? || current_user.admin?

    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
