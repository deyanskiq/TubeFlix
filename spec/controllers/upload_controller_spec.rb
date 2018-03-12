require 'rails_helper'
require 'spec_helper'

RSpec.configure {|c| c.before { expect(controller).not_to be_nil }}

RSpec.describe UploadsController, :type => :controller do
  describe 'test' do

    context 'methods' do

      before(:all) {User.all.map(&:destroy)}

      let(:user) {User.create(id: 1, name: 'test', email: 'test@abv.bg', password: '123123', role: 'Reseller')}
      #
      # it 'Upload has been successfully removed' do
      #   user
      #   binding.pry
      #   a = Upload.create(id: 1, name: 'upload', user_id: 1, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)
      #   b = delete :destroy, params: {id: 1}
      #
      #   expect(Upload.all.empty?).to be true
      # end

      it 'Upload has been successfully created' do
        user
        # a = Upload.create(id: 1, name: 'upload', user_id: 1, video_file_name: 'SampleVideo_1280x720_1mb.mp4', video_content_type: 'video/mp4', video_file_size: 1055736)

        # expect(Upload.all.empty?).to be true
      end


      it 'Upload is removed when it/s owner/s creator is removed via compound_destoy' do

      end
    end
  end
end

# да валидирам че upload работи - че има job Който завършва
#