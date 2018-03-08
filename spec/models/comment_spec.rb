require 'rails_helper'
require 'spec_helper'

describe 'Comment' do

  context 'test' do

    before(:all) {User.all.map(&:destroy)}
    before(:all) {Upload.all.map(&:destroy)}

    let(:user) {User.create(id: 1, name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}
    let(:upload) {Upload.create(id: 1, name: 'upload', user_id: 1, video_file_name: "SampleVideo_1280x720_1mb.mp4", video_content_type: "video/mp4", video_file_size: 1055736)}


    it 'validates successfully' do
      user
      upload
      a = Comment.new(upload_id: 1, user_id: 1, body: "test")
      expect(a.save).to be true

    end

    it 'negative test when body do not presence' do
      user
      upload
      a = Comment.new(id: 1)
      expect(a.save).to be false

    end
  end
end