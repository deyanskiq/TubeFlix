require 'rails_helper'
require 'spec_helper'


describe 'Upload' do

  context 'test' do

    before(:all) {User.all.map(&:destroy)}

    let(:user) { User.create(name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller') }


    it 'has belong to User' do
      userId  = user.id
      a = Upload.create(name: 'upload',user_id: userId)
      expect(a.user_id == userId).to be true

    end


  end
end