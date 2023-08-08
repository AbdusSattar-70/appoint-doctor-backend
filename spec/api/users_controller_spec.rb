require 'swagger_helper'
require 'devise/jwt/test_helpers'
require 'user_schema'
require 'common_data'

RSpec.describe UsersController, type: :request do
  before(:each) do
    @regular_user_params = CommonData.regular_user_params
    @doctor_params = CommonData.doctor_params
  end

  describe 'GET /users' do
    path '/users' do
      get 'Retrieve all users' do
        tags 'Users'
        produces 'application/json'

        response '200', 'users found' do
          run_test! do |response|
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to be_an_instance_of(Array)
          end
        end
      end
    end
  end

  describe 'GET /users/{id}' do
    path '/users/{id}' do
      get 'Retrieve a user' do
        tags 'Users'
        produces 'application/json'
        parameter name: :id, in: :path, type: :string

        response '200', 'user found' do
          let(:user) { User.create(@regular_user_params[:user]) }
          let(:id) { user.id }

          run_test! do |response|
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to include(
              'id' => user.id,
              'name' => user.name,
              'email' => user.email
            )
          end
        end
      end
    end
  end
end
