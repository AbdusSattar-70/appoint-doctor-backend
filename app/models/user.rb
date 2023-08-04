class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :doctor_appointments, class_name: 'Appointment', foreign_key: 'doctor_id'
  has_many :patient_appointments, class_name: 'Appointment', foreign_key: 'patient_id'
  before_save :downcase_role

  scope :doctors, -> { where(role: 'doctor') }
  scope :patients, -> { where(role: 'patient') }
  scope :admin_users, -> { where(role: 'admin') }

  validates :name, :email, :photo, :age, :role, :address, presence: true
  validates :password, :password_confirmation, presence: true, length: { minimum: 6}

  ROLES = %w[super_admin admin doctor patient ].freeze

  ROLES.each do |role_name|
    define_method "#{role_name}?" do
      role_name == role
    end
  end

  def appointments
    case role
    when 'doctor'
      doctor_appointments
    when 'patient'
      patient_appointments
    else
      []
    end
  end

  def valid_name?(name)
    self.name == name
  end

  private

  def downcase_role
    self.role = role.downcase
  end
end
