require 'rails_helper'
RSpec.describe Appointment, type: :model do
  let(:patient) { create(:user, :patient) }
  let(:doctor) { create(:user, :doctor) }
  let(:patient_token) { Devise::JWT::TestHelpers.auth_headers({}, patient)['Authorization'] }
  let(:doctor_token) { Devise::JWT::TestHelpers.auth_headers({}, doctor)['Authorization'] }

  let(:appointment_params) do
    {
      appointment_date: '2023-08-10',
      patient_id: patient.id,
      doctor_id: doctor.id,
      status: { active: true, expire: false, cancel: false },
      location: {
        street: '123 Main St',
        state: 'CA',
        city: 'Los Angeles',
        zip_code: '90001'
      }
    }
  end

  context 'validations' do
    let(:appointment1) { Appointment.new(appointment_params) }
    let(:appointment2) { Appointment.new(appointment_params) }

    it 'is not valid when appointment date is nil' do
      appointment1.appointment_date = nil
      expect(appointment1).not_to be_valid
    end

    it 'is not valid when patient is not present' do
      appointment1.patient_id = nil
      expect(appointment1).not_to be_valid
    end

    it 'is not valid when doctor is not present' do
      appointment1.doctor_id = nil
      expect(appointment1).not_to be_valid
    end

    it 'is valid with all required attributes' do
      expect(appointment1).to be_valid
      expect(appointment2).to be_valid
    end
  end
end
