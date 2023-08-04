class Appointment < ApplicationRecord
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id'
  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'

  validates :appointment_date, :doctor_id, :patient_id, :status, :location, presence: true

  scope :for_doctor, ->(doctor_id) { where(doctor_id:) }
  scope :for_patient, ->(patient_id) { where(patient_id:) }
end
