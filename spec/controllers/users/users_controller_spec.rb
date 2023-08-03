# spec/controllers/users_controller_spec.rb

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:super_admin) { create(:user, role: 'super_admin') }
  let(:admin) { create(:user, role: 'admin') }
  let(:doctor) { create(:user, role: 'doctor') }
  let(:patient) { create(:user, role: 'patient') }

  describe 'GET #index' do
    it 'returns a list of all users' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to match_array([
        super_admin.as_json(only: %i[id name role]),
        admin.as_json(only: %i[id name role]),
        doctor.as_json(only: %i[id name role]),
        patient.as_json(only: %i[id name role])
      ])
    end

    context 'when role parameter is specified' do
      it 'returns a list of users with the specified role' do
        get :index, params: { role: 'doctor' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match_array([doctor.as_json(only: %i[id name role])])
      end
    end

    context 'when role parameter is invalid' do
      it 'returns a list of all users' do
        get :index, params: { role: 'invalid_role' }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to match_array([
          super_admin.as_json(only: %i[id name role]),
          admin.as_json(only: %i[id name role]),
          doctor.as_json(only: %i[id name role]),
          patient.as_json(only: %i[id name role])
        ])
      end
    end
  end

  describe 'GET #show' do
    it 'returns the user details' do
      get :show, params: { id: doctor.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(doctor.as_json)
    end

    it 'returns an error for non-existing user' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('User not found')
    end
  end

  describe 'DELETE #destroy' do
    context 'when the user is super admin or admin' do
      before do
        request.headers['Authorization'] = "Bearer #{super_admin.generate_jwt}"
      end

      it 'destroys the user' do
        expect { delete :destroy, params: { id: doctor.id } }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end

      it 'returns an error for non-existing user' do
        delete :destroy, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('User not found')
      end
    end

    context 'when the user is not authorized' do
      before do
        request.headers['Authorization'] = "Bearer #{doctor.generate_jwt}"
      end

      it 'does not destroy the user' do
        expect { delete :destroy, params: { id: admin.id } }.not_to change(User, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
