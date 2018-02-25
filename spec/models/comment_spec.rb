require 'rails_helper'
require 'spec_helper'

describe 'Comment' do

  context 'test' do

    before(:all) {User.all.map(&:destroy)}

    let(:user) {User.create(id: 1, name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}
    let(:upload) {Upload.create(name: 'upload', user_id: 1)}


    it 'ff' do

      Comment.create(body: "test")
      raise unless 1 == 1

    end
  end
end