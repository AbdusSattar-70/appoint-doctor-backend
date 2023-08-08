# spec/controllers/appointments_controller_spec.rb
# rubocop:disable Metrics/BlockLength
require 'swagger_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'Appointments API', type: :request do
  let(:patient) { create(:user, :patient) }
  let(:doctor) { create(:user, :doctor) }

  let(:patient_token) { Devise::JWT::TestHelpers.auth_headers({}, patient)['Authorization'] }
  let(:doctor_token) { Devise::JWT::TestHelpers.auth_headers({}, doctor)['Authorization'] }

  describe 'POST /appointments' do
    path '/appointments' do
      post 'Create an appointment' do
        tags 'Appointments'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string, description: 'Authorization token', required: true
        parameter name: :appointment, in: :body, schema: {
          type: :object,
          properties: {
            appointment_date: { type: :string, format: :date }, patient_id: { type: :integer },
            doctor_id: { type: :integer }, status: { type: :string, enum: %w[active expire cancel] },
            location: { type: :object,
                        properties: { street: { type: :string }, state: { type: :string },
                                      city: { type: :string }, zip_code: { type: :string } } }
          },
          required: %w[appointment_date patient_id doctor_id status location]
        }

        response '201', 'appointment created' do
          let(:Authorization) { patient_token }
          let(:appointment) do
            { appointment_date: '2023-08-10', patient_id: patient.id, doctor_id: doctor.id,
              status: { active: true, expire: false, cancel: false },
              location: { street: '123 Main St', state: 'CA', city: 'Los Angeles', zip_code: '90001' } }
          end
          run_test!
        end

        response '422', 'unprocessable entity' do
          let(:Authorization) { patient_token }
          let(:appointment) { { appointment: { appointment_date: '2023-08-10' } } }
          run_test!
        end

        it 'returns a list of appointments' do
          get '/appointments', headers: { Authorization: patient_token }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to be_an(Array)
        end
      end
    end
  end
end

RSpec.describe 'Appointments API', type: :request do
  let(:patient) { create(:user, :patient) }
  let(:doctor) { create(:user, :doctor) }

  let(:patient_token) { Devise::JWT::TestHelpers.auth_headers({}, patient)['Authorization'] }
  let(:doctor_token) { Devise::JWT::TestHelpers.auth_headers({}, doctor)['Authorization'] }

  describe 'POST /appointments' do
    path '/appointments' do
      post 'Create an appointment' do
        tags 'Appointments'
        consumes 'application/json'
        parameter name: :Authorization, in: :header, type: :string, description: 'Authorization token', required: true
        parameter name: :appointment, in: :body, schema: {
          type: :object,
          properties: {
            appointment_date: { type: :string, format: :date }, patient_id: { type: :integer },
            doctor_id: { type: :integer }, status: { type: :string, enum: %w[active expire cancel] },
            location: { type: :object,
                        properties: { street: { type: :string }, state: { type: :string },
                                      city: { type: :string }, zip_code: { type: :string } } }
          },
          required: %w[appointment_date patient_id doctor_id status location]
        }

        response '201', 'appointment created' do
          let(:Authorization) { patient_token }
          let(:appointment) do
            { appointment_date: '2023-08-10', patient_id: patient.id, doctor_id: doctor.id,
              status: { active: true, expire: false, cancel: false },
              location: { street: '123 Main St', state: 'CA', city: 'Los Angeles', zip_code: '90001' } }
          end
          run_test!
        end

        it 'returns a list of appointments' do
          get '/appointments', headers: { Authorization: patient_token }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to be_an(Array)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
