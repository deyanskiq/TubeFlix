require 'rails_helper'
require 'spec_helper'


describe UserController do

  context 'methods' do

    before(:all) {User.all.map(&:destroy)}

    let (:roles) {['Admin', 'Reseller', 'User']}
    let(:user) {User.create(id: 1, name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}


    # it 'blocks unauthenticated access' do
    #   sign_in nil
    #
    #   get :index
    #
    #   expect(response).to redirect_to(new_user_session_path)
    # end
    #
    # it 'allows authenticated access' do
    #   sign_in
    #
    #   get :index
    #
    #   expect(response).to be_success
    # end

    # it 'still exists when his owner has been removed' do
    #   user
    #   subordinate = User.create(id: 2, name: 'test2', email: 'test2@abv.bg', password: '123123', role: 'User', owner_id: 1)
    #   expect{ delete :destroy, params: {id: subordinate.id}}.to change(User, :count).by(1)
    #   # subordinate.reload
    #
    #   # expect(User.count).to be 1
    # end

    it 'has been removed when his owner had been removed' do
      user
      subordinate = User.create(id: 2, name: 'test2', email: 'test2@abv.bg', password: '123123', role: 'User', owner_id: 1)
      delete compound_destroy_path, params: {id: 2}
      expect(User.count).to be 0

    end

    # it 'User has been successfully created via controller user and action create' do
    #   user
    #   post :create, params: {name: 'test2', email: 'test2@abv.bg', password: '123123', password_confirmation: '123123', role: 'User', owner_id: 1}
    #   expect(User.all).to be 2
    # end


  end
end