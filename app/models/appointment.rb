class Appointment < ApplicationRecord
  belongs_to :doctor, class_name: 'User'
  belongs_to :patient, class_name: 'User'
  validates :appointment_date, :doctor_id, :patient_id, :status, :location, presence: true
end
