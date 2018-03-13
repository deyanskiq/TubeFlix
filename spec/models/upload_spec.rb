require 'rails_helper'
require 'spec_helper'


describe 'Upload' do

  context 'Success on' do

    before(:all) {User.all.map(&:destroy)}
    let(:user) {User.create(name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}

    it 'has belong to User' do
      user
      a = Upload.create(name: 'upload', user_id: user.id)
      expect(a.user_id).to eq user.id
    end

    it 'has been validated successfully' do
      user
      a = Upload.new(name: 'upload', user_id: user.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      expect(a.save).to be true

    end

    it 'uploading video with existing name (not per user)' do
      user2 = User.create(name: 'test2', email: 'test2@abv.bg', password: '123123', role: 'Reseller')

      a = Upload.create(name: 'upload', user_id: user.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      b = Upload.new(name: 'upload', user_id: user2.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      expect(b.save).to be true
    end

    it 'deleting upload when user owner has been deleted' do
      a = Upload.new(name: 'upload', user_id: user.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      user.destroy
      expect(Upload.count).to be 0
    end
  end

  context 'Negative tests for' do

    before(:all) {User.all.map(&:destroy)}
    let(:user) {User.create(name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}

    it 'is invalid without a message' do
      upload = Upload.new()
      upload.valid?
      expect(upload.errors[:name]).to include('can\'t be blank')
    end

    it 'missing video attributes' do
      user
      USER_ID = user.id
      a = Upload.new(name: 'upload', user_id: USER_ID)
      expect(a.save).to be false

    end

    it 'name uniqueness' do
      user
      USER_ID = user.id
      a = Upload.create(name: 'upload', user_id: USER_ID, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      b = Upload.new(name: 'upload', user_id: USER_ID, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

      expect(b.save).to be false
    end

    it 'too short name' do
      user
      USER_ID = user.id
      a = Upload.new(name: 'a', user_id: USER_ID)
      expect(a.save).to be false

    end

    it 'too large file' do
      user
      USER_ID = user.id
      a = Upload.new(name: 'aa', user_id: USER_ID, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 105573611111)
      expect(a.save).to be false

    end

    it 'unsupported media type' do
      user
      USER_ID = user.id
      a = Upload.new(name: 'aa', user_id: USER_ID, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/avi', video_file_size: 10557)
      expect(a.save).to be false

    end

    it 'uniqueness of upload name per user' do
      user
      a = Upload.create(name: 'upload', user_id: user.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      b = Upload.new(name: 'upload', user_id: user.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      expect(b.save).to be false
    end

  end
end