require 'rails_helper'
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

  describe 'valid_name? method' do
    let(:user) { create(:user, :patient) }

    it 'returns true for valid name' do
      expect(user.valid_name?(user.name)).to eq(true)
    end

    it 'returns false for invalid name' do
      expect(user.valid_name?('John Doe5')).to eq(false)
    end
  end
  describe 'callbacks' do
    let(:user) { create(:user, :doctor) }
    it 'downcases the role before saving' do
      expect(user.role).to eq('doctor')
    end
  end
end
