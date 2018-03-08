require 'rails_helper'
require 'spec_helper'


describe 'Upload' do

  context 'test' do

    before(:all) {User.all.map(&:destroy)}
    let(:user) {User.create(name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}


    it 'has belong to User' do
      user
      USER_ID = user.id
      a = Upload.create(name: 'upload', user_id: USER_ID)
      expect(a.user_id == USER_ID).to be true
    end

    it 'has been validated successfully' do
      user
      USER_ID = user.id
      a = Upload.new(name: 'upload', user_id: USER_ID, video_file_name: "SampleVideo_1280x720_1mb.mp4", video_content_type: "video/mp4", video_file_size: 1055736)
      expect(a.save).to be true

    end

    it 'negative test for missing video attributes' do
      user
      USER_ID = user.id
      a = Upload.new(name: 'upload', user_id: USER_ID)
      expect(a.save).to be false

    end

    it 'negative test for name uniqueness' do
      user
      USER_ID = user.id
      a = Upload.create(name: 'upload', user_id: USER_ID, video_file_name: "SampleVideo_1280x720_1mb.mp4", video_content_type: "video/mp4", video_file_size: 1055736)
      b = Upload.new(name: 'upload', user_id: USER_ID, video_file_name: "SampleVideo_1280x720_1mb.mp4", video_content_type: "video/mp4", video_file_size: 1055736)

      expect(b.save).to be false
    end


    it 'negative test for too short name' do
      user
      USER_ID = user.id
      a = Upload.new(name: 'a', user_id: USER_ID)
      expect(a.save).to be false

    end

    it 'negative test for too large file' do
      user
      USER_ID = user.id
      a = Upload.new(name: 'aa', user_id: USER_ID, video_file_name: "SampleVideo_1280x720_1mb.mp4", video_content_type: "video/mp4", video_file_size: 105573611111)
      expect(a.save).to be false

    end

    it 'negative test for unsupported media type' do
      user
      USER_ID = user.id
      a = Upload.new(name: 'aa', user_id: USER_ID, video_file_name: "SampleVideo_1280x720_1mb.mp4", video_content_type: "video/avi", video_file_size: 10557)
      expect(a.save).to be false

    end


  end
end