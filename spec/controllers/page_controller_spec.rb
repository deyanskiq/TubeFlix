require 'rails_helper'
require 'spec_helper'

describe PagesController do

  it '#GET about' do
    get :about
    expect(response).to be_success
  end

  it '#GET home' do
    @user = User.create(id: 1, name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')
    sign_in @user

    get :home
    expect(response).to be_success
  end

  it 'Negative test for #GET home' do
    get :home
    expect(response).to be_redirect
  end

end