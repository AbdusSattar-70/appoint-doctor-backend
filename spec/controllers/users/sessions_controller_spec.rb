# spec/controllers/users/sessions_controller_spec.rb

require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  describe 'POST #create' do
    let(:user) { create(:user, name: 'John Doe', email: 'john@example.com', password: 'password') }

    context 'with valid credentials' do
      it 'returns a successful response with JWT token' do
        post :create, params: { user: { email: user.email, password: 'password', name: 'John Doe' } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Successfully Signed In')
        expect(JSON.parse(response.body)['token']).to be_present
      end
    end

    context 'with invalid email' do
      it 'returns an error response with code 401' do
        post :create, params: { user: { email: 'invalid_email@example.com', password: 'password', name: 'John Doe' } }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq('Invalid email')
        expect(JSON.parse(response.body)['data']['code']).to eq(401)
      end
    end

    context 'with invalid password' do
      it 'returns an error response with code 403' do
        post :create, params: { user: { email: user.email, password: 'wrong_password', name: 'John Doe' } }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq('Invalid password')
        expect(JSON.parse(response.body)['data']['code']).to eq(403)
      end
    end

    context 'with invalid name' do
      it 'returns an error response with code 404' do
        post :create, params: { user: { email: user.email, password: 'password', name: 'Invalid Name' } }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq('Invalid name')
        expect(JSON.parse(response.body)['data']['code']).to eq(404)
      end
    end

    context 'with user not valid for authentication' do
      before { user.update(disabled: true) }

      it 'returns an error response with code 402' do
        post :create, params: { user: { email: user.email, password: 'password', name: 'John Doe' } }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['message']).to eq('Invalid name or password')
        expect(JSON.parse(response.body)['data']['code']).to eq(402)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    context 'with valid JWT token' do
      let(:jwt_token) { JWT.encode({ sub: user.id }, Rails.application.credentials.fetch(:secret_key_base)) }

      before do
        request.headers['Authorization'] = "Bearer #{jwt_token}"
      end

      it 'signs out the user successfully' do
        delete :destroy
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']['message']).to eq('User Signed Out Successfully!')
      end
    end

    context 'with missing JWT token' do
      it 'returns an error response with code 401' do
        delete :destroy
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['code']).to eq(401)
        expect(JSON.parse(response.body)['status']['message']).to eq('Unauthorized: Missing JWT token')
      end
    end

    context 'with invalid JWT token' do
      before do
        request.headers['Authorization'] = 'Bearer invalid_token'
      end

      it 'returns an error response with code 401' do
        delete :destroy
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['code']).to eq(401)
        expect(JSON.parse(response.body)['status']['message']).to eq('Unauthorized: Invalid JWT token')
      end
    end

    context 'when user is not found for the given JWT token' do
      let(:jwt_token) { JWT.encode({ sub: 999 }, Rails.application.credentials.fetch(:secret_key_base)) }

      before do
        request.headers['Authorization'] = "Bearer #{jwt_token}"
      end

      it 'returns an error response with code 401' do
        delete :destroy
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['code']).to eq(401)
        expect(JSON.parse(response.body)['status']['message']).to eq('Cannot find user active session')
      end
    end
  end
end
