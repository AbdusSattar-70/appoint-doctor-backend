require 'rails_helper'
​
RSpec.describe Appointment, type: :model do
  let(:patient) { create(:user, :patient) }
  let(:doctor) { create(:user, :doctor) }
  let(:patient_token) { Devise::JWT::TestHelpers.auth_headers({}, patient)['Authorization'] }
  let(:doctor_token) { Devise::JWT::TestHelpers.auth_headers({}, doctor)['Authorization'] }