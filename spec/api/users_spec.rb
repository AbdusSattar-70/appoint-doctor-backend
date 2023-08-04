# users_spec.rb

require 'swagger_helper'
require 'devise/jwt/test_helpers'
require 'user_schema'
require 'common_data'

RSpec.describe 'Users API', type: :request do
  before(:each) do
    @regular_user_params = CommonData.regular_user_params
    @doctor_params = CommonData.doctor_params
  end

  describe 'POST /users' do
    path '/users' do
      post 'Create a user' do
        tags 'Users'
        consumes 'application/json'
        parameter name: :user, in: :body, schema: UserSchema.schema

        response '200', 'successful for regular user' do
          let(:user) { @regular_user_params }
          run_test! do |response|
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to include(
              'status' => { 'code' => 200, 'message' => 'User Created Successfully!', 'data' => an_instance_of(Hash) }
            )
          end
        end

        response '200', 'successful for doctor' do
          let(:user) { @doctor_params }
          run_test! do |response|
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to include(
              'status' => { 'code' => 200, 'message' => 'Doctor Created Successfully!', 'data' => an_instance_of(Hash) }
            )
          end
        end
      end
    end
  end
end

RSpec.describe 'Users API', type: :request do
  before(:each) do
    @regular_user_params = CommonData.regular_user_params
    @doctor_params = CommonData.doctor_params
  end

  describe 'POST /users' do
    path '/users' do
      post 'Create a user' do
        tags 'Users'
        consumes 'application/json'
        parameter name: :user, in: :body, schema: UserSchema.schema

        response '422', 'unprocessable entity' do
          let(:user) { { user: { name: 'Invalid User' } } }
          run_test! do |response|
            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)).to include(
              'status' => {
                'code' => 422,
                'message' => 'Unable to Create User',
                'errors' => an_instance_of(Array)
              }
            )
          end
        end
      end
    end
  end
end
