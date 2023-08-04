# spec/controllers/appointments_controller_spec.rb

require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  let(:doctor) { create(:user, role: 'doctor') }
  let(:patient) { create(:user, role: 'patient') }

  describe 'GET #show' do
    it 'returns the appointment details' do
      appointment = create(:appointment)
      get :show, params: { id: appointment.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq(appointment.as_json)
    end

    it 'returns an error for non-existing appointment' do
      get :show, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Appointment not found')
    end
  end

  describe 'POST #create' do
    context 'when the user is a doctor' do
      before do
        request.headers['Authorization'] = "Bearer #{doctor.generate_jwt}"
      end

      it 'creates an appointment with the doctor as the creator' do
        appointment_params = attributes_for(:appointment, doctor_id: nil)
        post :create, params: { appointment: appointment_params }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['doctor_id']).to eq(doctor.id)
      end
    end

    context 'when the user is a patient' do
      before do
        request.headers['Authorization'] = "Bearer #{patient.generate_jwt}"
      end

      it 'creates an appointment with the patient as the creator' do
        appointment_params = attributes_for(:appointment, patient_id: nil)
        post :create, params: { appointment: appointment_params }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['patient_id']).to eq(patient.id)
      end
    end

    context 'when the appointment params are invalid' do
      it 'returns an error' do
        post :create, params: { appointment: { appointment_date: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('appointment_date')
      end
    end
  end

  describe 'PATCH #update' do
    it 'updates the appointment' do
      appointment = create(:appointment)
      new_date = appointment.appointment_date + 1.day
      patch :update, params: { id: appointment.id, appointment: { appointment_date: new_date } }
      expect(response).to have_http_status(:ok)
      expect(appointment.reload.appointment_date).to eq(new_date)
    end

    it 'returns an error for non-existing appointment' do
      patch :update, params: { id: 999, appointment: { appointment_date: Time.now } }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Appointment not found')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the appointment' do
      appointment = create(:appointment)
      expect { delete :destroy, params: { id: appointment.id } }.to change(Appointment, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'returns an error for non-existing appointment' do
      delete :destroy, params: { id: 999 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Appointment not found')
    end
  end
end
