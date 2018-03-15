require 'rails_helper'
require 'spec_helper'


describe UserController do
# expect(response).to be_success
# expect(response).to be_error
# expect(response).to be_missing
# expect(response).to be_redirect
#
  context 'Authenticate user' do
    before :each do
      @john = User.create(id: 1, name: 'john', email: 'john@abv.bg', password: '123123', role: 'Reseller')
    end

    it 'blocks unauthenticated access' do
      sign_in nil

      get :index

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'allows authenticated access' do
      sign_in @john

      get :index

      expect(response).to be_success
    end

    # it 'allows sign out' do
    #   sign_in @john
    #
    #   # get :index
    #   # expect(response).to be_success
    #
    #   sign_out @john
    #
    #   get :index
    #   expect(response).to redirect_to user_session_path

  end

  context 'Success on' do

    before(:all) {User.all.map(&:destroy)}

    let (:roles) {['Admin', 'Reseller', 'User']}

    before :each do
      @john = User.create(id: 1, name: 'john', email: 'john@abv.bg', password: '123123', role: 'Reseller')
      sign_in @john
    end

    it '#GET index' do
      get :index
      expect(response).to be_success
    end

    it '#GET show' do

      get :show, params: {id: @john.id}
      expect(response).to be_success
    end

    it '#GET edit' do

      get :edit, params: {id: @john.id}
      expect(response).to be_success
    end

    it '#GET new' do

      get :new, params: {id: @john.id}
      expect(response).to be_success
    end

    # it '#PATCH user update' do
    #   patch :update, params: {id: 1, name: 'tom', email: 'tom@abv.bg'}
    #   @john.reload
    #
    #   expect(@john.name).eq('tom')
    #   expect(@john.email).eq('tom@abv.bg')
    # end

    # it '#PATCH user update his own information' do
    #   patch :update, params: {id: 1, name: 'tom', email: 'tom@abv.bg'}
    #   @john.reload
    #   expect(response).to redirect_to new_user_session_path
    # end

    # it '#PATCH user update other user information' do
    # tom = User.create(id: 3, name: 'tom', email: 'tom@abv.bg', password: '123123', role: 'Reseller')
    #   patch :update, params: {id: 3, name: 'tom-edited', email: 'tom_edited@abv.bg'}
    #   @john.reload
    #   expect(response).to redirect_to user_index_path
    # end
    #


    # it 'POST create - redirecting when user has been created' do
    #   post :create, params: {name: 'test2', email: 'test2@abv.bg', password: '123123', password_confirmation: '123123', role: 'User', owner_id: 1}
    #   expect(response).to be_success
    #
    #
    # end

    # it '#POST create - saves new user in the database' do
    #   expect {
    #     post :create, params: {name: 'tom', email: 'tom@abv.bg', password: '123123', password_confirmation: '123123'}
    #   }.to change(User, :count).by(1)
    #   tom = User.where(email => 'tom@abv.bg')
    #   expect(tom.owner_id).to be john.id
    # end


    # it '#DELETE destroy - still exists when his owner has been removed' do
    #
    #   subordinate = User.create(id: 2, name: 'test2', email: 'test2@abv.bg', password: '123123', role: 'User', owner_id: 1)
    #   expect{ delete :destroy, params: {id: subordinate.id}}.to change(User, :count).by(1)
    #   # subordinate.reload
    #
    #   # expect(User.count).to be 1
    # end

    # it '#DELETE compound_destroy - has been removed when his owner had been removed' do
    #
    #   subordinate = User.create(id: 2, name: 'test2', email: 'test2@abv.bg', password: '123123', role: 'User', owner_id: 1)
    #   delete compound_destroy_path, params: {id: 2}
    #   expect(User.count).to be 0
    #
    # end

    # it '#POST create - User has been successfully created via controller user and action create' do
    #
    #   post :create, params: {name: 'test2', email: 'test2@abv.bg', password: '123123', password_confirmation: '123123', role: 'User', owner_id: 1}
    #   expect(User.all).to be 2
    # end


  end
  context 'Negative test for' do
    before(:all) {User.all.map(&:destroy)}

    let (:roles) {['Admin', 'Reseller', 'User']}

    before :each do
      @john = User.create(id: 1, name: 'john', email: 'john@abv.bg', password: '123123', role: 'User')
      sign_in @john
    end


    # it 'POST create - doesn't  save invalid user in the database' do
    #   expect {
    #     post :create, params: {name: 't', email: 'test', password: '123123', password_confirmation: '123123', role: 'User', owner_id: 1}
    #   }.not_to change(User, :count)
    #
    # end

    # it '#PATCH invalid user information not updating' do
    #   patch :update, params: {id: 1,name: 'tom', email: nil}
    #   @john.reload
    #
    #   expect(@john.name).not_eq('tom')
    #   expect(@john.email).eq('john@abv.bg')
    # end

    it '#GET index - User isn\'t allowed to see users panel' do
      get :index
      expect(response.status).to eq(403)
    end

    # it '#POST create - User isn\'t allow to create new users' do
    #   post :create, params: {name: 'test2', email: 'test2@abv.bg', password: '123123', password_confirmation: '123123', role: 'User', owner_id: 1}
    #   expect(response.status).to eq(403)
    # end

    # it '#GET show - User isn\'t allowed to see other users\'s information' do
    #   tom = User.create(name: 'test2', email: 'test2@abv.bg', password: '123123', password_confirmation: '123123', role: 'Reseller', owner_id: 1)
    #   post :show, params: {id: tom.id}
    #   expect(response.status).to eq(403)
    # end
    #
    # it '#PATCH update - User isn\'t allowed to edit other users\'s information' do
    #   tom = User.create(name: 'test2', email: 'test2@abv.bg', password: '123123', password_confirmation: '123123', role: 'Reseller', owner_id: 1)
    #   patch :edit, params: {id: tom.id}
    #   expect(response.status).to eq(403)
    # end
    #
    # it '#DELETE destroy - User isn\'t allowed to edit other users\'s information' do
    #   tom = User.create(name: 'test2', email: 'test2@abv.bg', password: '123123', password_confirmation: '123123', role: 'Reseller', owner_id: 1)
    #   patch :edit, params: {id: tom.id}
    #   expect(response.status).to eq(403)
    # end
    #
  end

end