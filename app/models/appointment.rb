class Appointment < ApplicationRecord
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id', dependent: :destroy
  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id', dependent: :destroy

  validates :appointment_date, :doctor_id, :patient_id, :status, :location, presence: true
end
