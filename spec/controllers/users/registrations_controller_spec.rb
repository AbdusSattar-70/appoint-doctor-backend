# spec/controllers/users/registrations_controller_spec.rb

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  describe 'POST #create' do
    context 'when creating a regular user' do
      let(:regular_user_params) do
        {
          user: {
            name: 'John Doe',
            age: 30,
            email: 'john@example.com',
            photo: 'user_photo.png',
            role: 'regular',
            password: 'password',
            password_confirmation: 'password',
            address: {
              street: '123 Main St',
              city: 'Cityville',
              state: 'Stateland',
              zip_code: '12345'
            }
          }
        }
      end

      it 'creates a regular user successfully' do
        post :create, params: regular_user_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']['code']).to eq(200)
        expect(User.count).to eq(1)
      end

      it 'returns errors if user creation fails' do
        regular_user_params[:user][:name] = '' # Invalid name to trigger validation error
        post :create, params: regular_user_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']['code']).to eq(422)
        expect(User.count).to eq(0)
        expect(JSON.parse(response.body)['status']['errors']).to include("Name can't be blank")
      end
    end

    context 'when creating a doctor' do
      let(:doctor_params) do
        {
          user: {
            name: 'Dr. Smith',
            age: 40,
            email: 'smith@example.com',
            photo: 'doctor_photo.png',
            role: 'doctor',
            password: 'password',
            password_confirmation: 'password',
            address: {
              street: '456 Oak St',
              city: 'Townsville',
              state: 'Stateland',
              zip_code: '54321'
            },
            qualification: 'MBBS',
            description: 'Experienced doctor with expertise in internal medicine',
            experiences: '10+ years',
            available_from: '9:00 AM',
            available_to: '5:00 PM',
            consultation_fee: 100,
            rating: 4.8,
            specialization: 'Internal Medicine'
          }

        }
      end

      it 'creates a doctor successfully' do
        post :create, params: doctor_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']['code']).to eq(200)
        expect(User.count).to eq(1)
        expect(User.last.role).to eq('doctor')
      end

      it 'returns errors if doctor creation fails' do
        doctor_params[:user][:name] = '' # Invalid name to trigger validation error
        post :create, params: doctor_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['status']['code']).to eq(422)
        expect(User.count).to eq(0)
        expect(JSON.parse(response.body)['status']['errors']).to include("Name can't be blank")
      end
    end
  end
end
