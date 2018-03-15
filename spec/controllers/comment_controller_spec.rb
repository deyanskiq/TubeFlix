require 'rails_helper'
require 'spec_helper'


describe CommentsController do
  # expect(response).to be_success
  # expect(response).to be_error
  # expect(response).to be_missing
  # expect(response).to be_redirect

  context '(Signed in as Reseller) Success on' do

    before(:all) {User.all.map(&:destroy)}

    before :each do
      @john = User.create(id: 1, name: 'john', email: 'john@abv.bg', password: '123123', role: 'Reseller')
      @john_upload = Upload.create(id: 1, name: 'john-upload', user_id: @john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      @john_upload_comment = Comment.create(id: 1, upload_id: 1, user_id: 1, body: 'This is test comment')
      sign_in @john
    end

    it '#GET index' do

      get :index, params: {upload_id: @john_upload.id, id: @john_upload_comment.id}
      expect(response).to be_success
    end

    it '#GET show' do

      get :show, params: {upload_id: @john_upload.id, id: @john_upload_comment.id}
      expect(response).to be_success
    end

    it '#GET edit' do

      get :index, params: {upload_id: @john_upload.id, id: @john_upload_comment.id}
      expect(response).to be_success
    end

    # it '#POST create comment' do
    #   post :create, params: {upload_id: @john_upload.id, body: 'test-comment'}
    #   expect(response).to be_success
    #   expect(Comment.count).to eq(2)
    #
    # end
    #
    # it '#PATCH update comment' do
    #   patch :update, params: {upload_id: @john_upload.id, id: @john_upload_comment.id, body: 'test-comment-updated'}
    #   expect(@john_upload_comment.body).to eq('test-comment-updated')
    #   expect(response).to be_success
    # end

    it '#DELETE destroy comment' do
      delete :destroy, params: {upload_id: @john_upload.id, id: @john_upload_comment.id}
      expect(response).to redirect_to(upload_path(@john_upload))
      expect(Comment.count).to eq(0)

    end

    it '#DELETE destroy - reseller is allowed to delete his subordinate\'s comments' do
      @tom = User.create(id: 2, name: 'tom', email: 'tom@abv.bg', password: '123123', role: 'User', owner_id: 1)
      @tom_upload = Upload.create(id: 2, name: 'tom-upload', user_id: @tom.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      @tom_upload_comment = Comment.create(id: 2, upload_id: 2, user_id: 2, body: 'This is test comment')

      delete :destroy, params: {upload_id: @tom_upload.id, id: @tom_upload_comment.id}

      expect(response).to redirect_to(upload_path(@tom_upload))
      expect(Comment.count).to eq(1)
    end
  end

  context 'Negative test for' do

    before(:all) {User.all.map(&:destroy)}

    before :each do
      @john = User.create(id: 1, name: 'john', email: 'john@abv.bg', password: '123123', role: 'User')
      @john_upload = Upload.create(id: 1, name: 'john-upload', user_id: @john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      @john_upload_comment = Comment.create(id: 1, upload_id: 1, user_id: 1, body: 'This is test comment')
      sign_in @john
    end

    it '#DELETE destroy - user (logged in as User) isn\'t allow to delete comment which belongs to somebody else' do
      @tom = User.create(id: 2, name: 'tom', email: 'tom@abv.bg', password: '123123', role: 'User')
      @tom_upload = Upload.create(id: 2, name: 'tom-upload', user_id: @tom.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      @tom_upload_comment = Comment.create(id: 2, upload_id: 2, user_id: 2, body: 'This is test comment')

      delete :destroy, params: {upload_id: @tom_upload.id, id: @tom_upload_comment.id}
      expect(response.status).to eq(403)
    end
  end
end