# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:photo) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:role) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:password_confirmation) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'associations' do
    it { should have_many(:doctor_appointments).class_name('Appointment').with_foreign_key('doctor_id') }
    it { should have_many(:patient_appointments).class_name('Appointment').with_foreign_key('patient_id') }
  end

  describe 'role methods' do
    let(:user) { create(:user) }

    it 'defines role methods' do
      expect(user.super_admin?).to eq(false)
      expect(user.admin?).to eq(false)
      expect(user.doctor?).to eq(false)
      expect(user.patient?).to eq(false)
      expect(user.general?).to eq(true)
    end
  end

  describe 'appointments method' do
    let(:doctor) { create(:user, role: 'doctor') }
    let(:patient) { create(:user, role: 'patient') }

    it 'returns doctor appointments for doctors' do
      appointments = create_list(:appointment, 3, doctor_id: doctor.id)
      expect(doctor.appointments).to match_array(appointments)
    end

    it 'returns patient appointments for patients' do
      appointments = create_list(:appointment, 2, patient_id: patient.id)
      expect(patient.appointments).to match_array(appointments)
    end

    it 'returns an empty array for general users' do
      expect(User.new(role: 'general').appointments).to eq([])
    end
  end

  describe 'valid_name? method' do
    let(:user) { create(:user) }

    it 'returns true for valid name' do
      expect(user.valid_name?(user.name)).to eq(true)
    end

    it 'returns false for invalid name' do
      expect(user.valid_name?('John Doe')).to eq(false)
    end
  end

  describe 'callbacks' do
    it 'downcases the role before saving' do
      user = create(:user, role: 'Doctor')
      expect(user.role).to eq('doctor')
    end
  end
end
