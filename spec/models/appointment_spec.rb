# spec/models/appointment_spec.rb

require 'rails_helper'

RSpec.describe Appointment, type: :model do
  describe 'associations' do
    it { should belong_to(:doctor).class_name('User').with_foreign_key('doctor_id').dependent(:destroy) }
    it { should belong_to(:patient).class_name('User').with_foreign_key('patient_id').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:appointment_date) }
    it { should validate_presence_of(:doctor_id) }
    it { should validate_presence_of(:patient_id) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:location) }
  end
end
