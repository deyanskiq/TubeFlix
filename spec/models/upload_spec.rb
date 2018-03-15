require 'rails_helper'
require 'spec_helper'

describe 'Upload' do

  context 'Success on' do

    before(:all) {User.all.map(&:destroy)}
    let(:john) {User.create(name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}

    it 'has belong to User' do
      john
      john_upload = Upload.create(name: 'upload', user_id: john.id)
      expect(john_upload.user_id).to eq john.id
    end

    it 'has been validated successfully' do
      john
      john_upload = Upload.new(name: 'upload', user_id: john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      expect(john_upload.save).to be true

    end

    it 'uploading video with existing name (not per john)' do
      tom = User.create(name: 'test2', email: 'test2@abv.bg', password: '123123', role: 'Reseller')

      Upload.create(name: 'upload', user_id: john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      john_second_upload = Upload.new(name: 'upload', user_id: tom.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      expect(john_second_upload.save).to be true
    end

    it 'deleting upload when john owner has been deleted' do
      Upload.new(name: 'upload', user_id: john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      john.destroy
      expect(Upload.count).to be 0
    end

    # it 'uploading video in background job' do
    #
    # end
  end

  context 'Negative test for' do

    before(:all) {User.all.map(&:destroy)}
    let(:john) {User.create(name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}

    it 'is invalid without john_upload message' do
      upload = Upload.new()
      upload.valid?
      expect(upload.errors[:name]).to include('can\'t be blank')
    end

    it 'missing video attributes' do
      john
      john_upload = Upload.new(name: 'upload', user_id: john.id)
      expect(john_upload.save).to be false

    end

    it 'name uniqueness' do
      john
      Upload.create(name: 'upload', user_id: john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      john_second_upload = Upload.new(name: 'upload', user_id: john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

      expect(john_second_upload.save).to be false
    end

    it 'too short name' do
      john
      john_upload = Upload.new(name: 'john_upload', user_id: john.id)
      expect(john_upload.save).to be false

    end

    it 'too large file' do
      john
      john_upload = Upload.new(name: 'aa', user_id: john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 105573611111)
      expect(john_upload.save).to be false

    end

    it 'unsupported media type' do
      john
      john_upload = Upload.new(name: 'aa', user_id: john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/avi', video_file_size: 10557)
      expect(john_upload.save).to be false

    end

    it 'uniqueness of upload name per john' do
      john
      Upload.create(name: 'upload', user_id: john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      john_second_upload = Upload.new(name: 'upload', user_id: john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      expect(john_second_upload.save).to be false
    end

  end
end