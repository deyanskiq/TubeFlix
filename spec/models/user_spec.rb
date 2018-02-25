require 'rails_helper'
require 'spec_helper'


describe 'User' do

  context 'test' do

    before(:all) {User.all.map(&:destroy)}

    let (:roles) { ["Admin", "Reseller", "User"] }
    let(:user) { User.create(id: 1, name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller') }

    it 'has been created successfully' do
      user
      expect(User.count).to be 1
    end

    it 'has been deleted successfully' do
      user.destroy
      expect(User.count).to be 0
    end


    it 'has been updated successfully' do
      user.update_attribute(:name, "test-updated")
      expect(user.name) == "test-updated"
    end

    it 'has legit role' do
      expect(roles.include?(user.role)). to be true
    end


  end
end