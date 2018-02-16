class UploadsController < ApplicationController
    load_and_authorize_resource

    def index
    end

    def create
        @upload = Upload.create(upload_params)
      end
      
      private
      
      # Use strong_parameters for attribute whitelisting
      # Be sure to update your create() and update() controller methods.
      
      def upload_params
        params.require(:upload).permit(:path,:name)
      end
      
      def destroy
        @user.path = nil
        @user.save
      end
end