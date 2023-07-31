class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :doctor_appointments, foreign_key: 'doctor_id', class_name: 'Appointment'
  has_many :patient_appointments, foreign_key: 'patient_id', class_name: 'Appointment'
  validates :name, :email, :photo, :age, :role, :address, presence: true
  validates :password, :password_confirmation, presence: true, length: { minimum: 6 }
end
