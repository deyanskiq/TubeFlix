require 'rails_helper'
require 'spec_helper'


describe UploadsController do
  # expect(response).to be_success
  # expect(response).to be_error
  # expect(response).to be_missing
  # expect(response).to be_redirect

  context '(Signed in as Reseller) Success on' do

    before(:all) {User.all.map(&:destroy)}

    before :each do
      @john = User.create(id: 1, name: 'john', email: 'john@abv.bg', password: '123123', role: 'Reseller')
      @john_upload = Upload.create(id: 1, name: 'john-upload', user_id: @john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

      sign_in @john
    end

    it '#GET index' do
      get :index
      expect(response).to be_success
    end

    it '#GET show' do
      get :show, params: {id: @john_upload.id}
      expect(response).to be_success
    end

    it '#GET show - increment counter' do
      get :show, params: {id: @john_upload.id}
      @john_upload.reload
      expect(@john_upload.hit_counter).to be 1
    end
    #
    # it 'GET update' do
    #   get :update, params: {id: @john_upload.id, name: 'john-upload-updated'}
    #   expect(response).to be_success
    # end

    it '#GET new' do
      get :new
      expect(response).to be_success
    end

    it '#GET show - show subordinate upload' do
      @tom = User.create(id: 2, name: 'tom', email: 'tom@abv.bg', password: '123123', role: 'User', owner_id: 1)
      @tom_upload = Upload.create(id: 2, name: 'tom-upload', user_id: @tom.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

      get :show, params: {id: @tom_upload.id}
      expect(response).to be_success
    end

    # it '#PATCH update - update subordinate upload' do
    #   @tom = User.create(id: 2, name: 'tom', email: 'tom@abv.bg', password: '123123', role: 'User', owner_id: 1)
    #   @tom_upload = Upload.create(id: 2, name: 'tom-upload', user_id: @tom.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
    #
    #   patch :update, params: {id: @tom_upload.id, name: 'tom-upload-updated'}
    #   expect(@tom_upload.name).to eq('tom-upload-updated')
    # end

    it '#DELETE destroy - destroy subordinate upload' do
      @tom = User.create(id: 2, name: 'tom', email: 'tom@abv.bg', password: '123123', role: 'User', owner_id: 1)
      @tom_upload = Upload.create(id: 2, name: 'tom-upload', user_id: @tom.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      delete :destroy, params: {id: @tom_upload.id}
      expect(Upload.count).to eq(1)
    end


    # it '#POST create - Upload has been successfully created' do
    #
    # expect {
    #     post :create, params: {id: 2, name: 'john-second-upload', video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736}
    #   }.to change(Upload, :count).by(1)
    #
    # expect(Upload.count).to be 1
    # end

    # it '#POST create - User id has been assign to upload' do
    #
    #     post :create, params: {id: 2, name: 'john-second-upload', video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736}
    #     expect(Upload.where(id => 2).user_id).to be (1)
    # end
    #

    # it '#PATCH update' do
    #   patch :update, params: {name: 'john-upload-updated'}
    #   expect(@john_upload.name).eq ('john-upload-updated')
    #
    # end


    # it '#DELETE destroy - Upload has been successfully removed' do
    #    expect {
    #     delete :destroy, params: {id:1}
    #   }.to change(Upload, :count).by(1)
    #   expect(Upload.all.empty?).to be true
    # end


    # it 'Upload is removed when it/s owner/s creator is removed via compound_destroy' do
    #
    # end
  end
  context '(Signed in as User) Success on ' do
    before(:all) {User.all.map(&:destroy)}

    before :each do
      @john = User.create(id: 1, name: 'john', email: 'john@abv.bg', password: '123123', role: 'User')
      @john_upload = Upload.create(id: 1, name: 'john-upload', user_id: @john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

      sign_in @john

      it '#GET show - allow to see his owner\'s upload' do
        @tom = User.create(id: 2, name: 'tom', email: 'tom@abv.bg', password: '123123', role: 'Reseller', owner_id: 1)
        @tom_upload = Upload.create(id: 2, name: 'tom-upload', user_id: @tom.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

        get :show, params: {id: @tom_upload.id}
        expect(response).to be_success
      end

      it '#GET show - successfully showing  user (from same reseller)  upload ' do
        @mike = User.create(id: 3, name: 'mike', email: 'mike@abv.bg', password: '123123', role: 'User', owner_id: 1)
        @mike_upload = Upload.create(id: 2, name: 'mike-upload', user_id: @mike.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

        get :show, params: {id: @mike_upload.id}
        expect(response).to be_success
      end


    end
  end
  context 'Negative test for' do
    before(:all) {User.all.map(&:destroy)}

    before :each do
      @tom = User.create(id: 1, name: 'tom', email: 'tom@abv.bg', password: '123123', role: 'Reseller')
      @john = User.create(id: 2, name: 'john', email: 'john@abv.bg', password: '123123', role: 'User', owner_id: 1)
      @john_upload = Upload.create(id: 1, name: 'john-upload', user_id: @john.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

      sign_in @john
    end

    it '#GET show - fail to show random user upload (neither his, nor his owner upload)' do
      @mike = User.create(id: 3, name: 'mike', email: 'mike@abv.bg', password: '123123', role: 'Reseller')
      @mike_upload = Upload.create(id: 2, name: 'mike-upload', user_id: @mike.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

      get :show, params: {id: @mike_upload.id}
      expect(response.status).to be(403)
    end

    it '#PATCH update - fail to update user (from the same reseller) upload ' do
      @mike = User.create(id: 3, name: 'mike', email: 'mike@abv.bg', password: '123123', role: 'User', owner_id: 1)
      @mike_upload = Upload.create(id: 2, name: 'mike-upload', user_id: @mike.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

      patch :update, params: {id: @mike_upload.id, name: 'mike-upload-update'}
      expect(response.status).to be(403)
    end

    it '#PATCH update - fail to update his owner\'s upload' do
      @tom_upload = Upload.create(id: 2, name: 'tom-upload', user_id: @tom.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

      patch :update, params: {id: @tom_upload.id, name: 'tom-upload-updated'}
      expect(response.status).to be(403)
    end

    it '#DELETE destroy - fail to delete user (from the same reseller) upload ' do
      @mike = User.create(id: 3, name: 'mike', email: 'mike@abv.bg', password: '123123', role: 'User', owner_id: 1)
      @mike_upload = Upload.create(id: 2, name: 'mike-upload', user_id: @mike.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

      delete :destroy, params: {id: @mike_upload.id}
      expect(response.status).to be(403)
    end

    it '#DELETE destroy - destroy subordinate upload' do
      @tom_upload = Upload.create(id: 2, name: 'tom-upload', user_id: @tom.id, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      delete :destroy, params: {id: @tom_upload.id}
      expect(response.status).to eq(403)
      expect(Upload.count).to eq(2)
    end

  end
end
