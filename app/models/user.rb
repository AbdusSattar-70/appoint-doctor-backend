class User < ApplicationRecord
  has_many :doctor_appointments, foreign_key: 'doctor_id', class_name: 'Appointment'
  has_many :patient_appointments, foreign_key: 'patient_id', class_name: 'Appointment'
  validates :name, :email, :photo, :age, :role, :address, presence: true
  validates :password, :password_confirmation, presence: true, length: { minimum: 6 }
end
