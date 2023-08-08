# spec/models/user_spec.rb
​
require 'rails_helper'
​
RSpec.describe User, type: :model do
  describe 'role methods' do
    let(:user1) { create(:user, :patient) }
    let(:user2) { create(:user, :doctor) }

    it 'defines role methods' do
        expect(user1.super_admin?).to eq(false)
        expect(user2.admin?).to eq(false)
        expect(user2.doctor?).to eq(true)
        expect(user1.patient?).to eq(true)
      end
    end