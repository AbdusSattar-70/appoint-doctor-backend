# spec/models/user_spec.rb
​
require 'rails_helper'
​
RSpec.describe User, type: :model do
  describe 'role methods' do
    let(:user1) { create(:user, :patient) }
    let(:user2) { create(:user, :doctor) }