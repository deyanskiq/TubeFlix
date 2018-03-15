require 'rails_helper'
require 'spec_helper'


describe 'User' do

  context 'Sucess on: User' do

    before(:all) {User.all.map(&:destroy)}

    let (:roles) {['Admin', 'Reseller', 'User']}
    let(:john) {User.create(id: 1, name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}

    it 'is a valid with name, email, and password' do
      tom = User.new(name: 'test2', email: 'test2@abv.bg', password: '123123', role: 'User')
      expect(tom).to be_valid
    end

    it 'has been created successfully' do
      expect(User.count).to be 0
      john
      expect(User.count).to be 1
    end

    it 'has been deleted successfully' do
      john
      expect(User.count).to be 1
      john.destroy
      expect(User.count).to be 0
    end


    it 'has been updated successfully' do
      john.update_attribute(:name, 'test-updated')
      expect(john.name).to eq 'test-updated'
    end

    it 'has legit role' do
      expect(roles.include?(john.role)).to be true
    end

    it 'is deleted when his owner is deleted' do
      john
      User.create(id: 2, name: 'test2', email: 'test2@abv.bg', password: '123123', role: 'User', owner_id: 1)
      expect(User.count).to be 2
      john.destroy
      expect(User.count).to be 0
    end

    # it 'when his role is Reseller, can successfully get all his subordinates' do
    #
    # end
  end

  context 'Negative test' do
    let(:john) {User.create(id: 1, name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}

    it 'validation fails due to empty email address' do
      tom = User.new(name: 'test2', password: '123123', role: 'User')
      tom.valid?
      expect(tom.errors[:email]).to include('can\'t be blank')
    end

    it 'validation fails due to empty john name' do
      tom = User.new(email: 'test2@abv.bg', password: '123123', role: 'User')
      tom.valid?
      expect(tom.errors[:name]).to include('can\'t be blank')
    end

    it 'validation fails due to invalid john name' do
      john
      tom = User.new(name: 'a', email: 'test2@abv.bg', password: '123123', role: 'User')
      tom.valid?
      expect(tom.errors[:name]).to include('is too short (minimum is 2 characters)')
    end

    it 'validation fails due to not unique john name' do
      john
      tom = User.new(name: 'test', email: 'test2@abv.bg', password: '123123', role: 'User')
      tom.valid?
      expect(tom.errors[:name]).to include('has already been taken')
    end

    it 'validation fails due to too short password' do
      tom = User.new(name: 'test2', email: 'test2@abv.bg', password: '123', role: 'User')
      tom.valid?
      expect(tom.errors[:password]).to include('is too short (minimum is 6 characters)')
    end

  end
end