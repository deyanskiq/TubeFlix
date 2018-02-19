class UploadsController < ApplicationController
    load_and_authorize_resource

    def index
    end

    def new
        @upload = Upload.new
    end

    def show
      @upload = Upload.find(params[:id])
    end
    
    def create
        @upload = Upload.new(upload_params)

        respond_to do |format|
            if @upload.save
              format.html { redirect_to uploads_path, notice: 'Video was successfully uploaded.' }
              format.json { render :show, status: :created, location: @upload }
            else
              format.html { render :edit }
              format.json { render json: @upload.errors, status: :unprocessable_entity }
            end
          end
      end
    
    def destroy
        @upload.destroy
        respond_to do |format|
          format.html { redirect_to uploads_path, notice: 'Video was successfully removed.' }
          format.json { head :no_content }
        end
    end

    def update
      respond_to do |format|
        if @upload.update(article_params)
          format.html { redirect_to uploads_path, notice: 'Video was successfully updated.' }
          format.json { render :show, status: :ok, location: @upload }
        else
          format.html { render :edit }
          format.json { render json: @upload.errors, status: :unprocessable_entity }
        end
      end
    end

      private
      
      # Use strong_parameters for attribute whitelisting
      # Be sure to update your create() and update() controller methods.
      
      def upload_params
        params.require(:upload).permit(:video,:name)
      end
end
