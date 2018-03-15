require 'rails_helper'
require 'spec_helper'

describe 'Comment' do

  context 'test' do

    before(:all) {User.all.map(&:destroy)}
    before(:all) {Upload.all.map(&:destroy)}

    let(:user) {User.create(id: 1, name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}
    let(:upload) {Upload.create(id: 1, name: 'upload', user_id: 1, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)}

    context 'Success on' do

      it 'validates successfully' do
        user
        upload
        a = Comment.new(upload_id: 1, user_id: 1, body: 'test')
        expect(a.save).to be true

      end
      it 'deleting comment when upload is deleted' do
        user
        upload
        Comment.create(upload_id: 1, user_id: 1, body: 'test')
        expect(Comment.count).to be 1
        upload.destroy
        expect(Comment.count).to be 0
      end

      it 'deleting comment when user (who is the creator of the upload ) is deleted' do
        user
        upload
        Comment.create(upload_id: 1, user_id: 1, body: 'test')
        expect(Comment.count).to be 1
        user.destroy

        expect(Comment.count).to be 0
      end
      it 'Comment body with maximum length' do
        user
        upload
        comment = Comment.create(upload_id: 1, user_id: 1, body: 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest')
        expect(comment.valid?).to be true

      end
    end

    context 'Negative test for' do

      before(:all) {User.all.map(&:destroy)}
      before(:all) {Upload.all.map(&:destroy)}

      let(:user) {User.create(id: 1, name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}
      let(:upload) {Upload.create(id: 1, name: 'upload', user_id: 1, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)}


      it 'body do not presence' do
        user
        upload
        a = Comment.new(id: 1)
        expect(a.save).to be false

      end
      it 'Comment body is too long' do
        user
        upload
        comment = Comment.create(upload_id: 1, user_id: 1, body: 'testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttestt')
        comment.valid?
        expect(comment.errors[:body]).to include('is too long (maximum is 100 characters)')

      end
    end
  end
end