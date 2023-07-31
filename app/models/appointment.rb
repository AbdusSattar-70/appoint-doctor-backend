class Appointment < ApplicationRecord
  belongs_to :doctor, class_name: 'User'
  belongs_to :patient, class_name: 'User'
end
