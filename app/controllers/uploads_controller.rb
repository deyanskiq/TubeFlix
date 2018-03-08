class UploadsController < ApplicationController
  load_and_authorize_resource
  skip_load_resource :only => :index

  def index
    if current_user.role == 'Admin'
      @uploads = Upload.admin_all
      # @uploads = @uploads.sort { |a,b| a.name <=> b.name }
    elsif current_user.role == 'Reseller'
      @uploads = Upload.scope_reseller(current_user)
    else
      @uploads = Upload.scope_user(current_user)
    end

    @uploads ||= []
  end

  def new
    @upload = Upload.new
  end

  def show
    @upload = Upload.find(params[:id])
    Upload.increment_counter(:hit_counter, @upload.id)
  end


  def create
    @upload = Upload.new(upload_params)
    @upload.user_id = current_user.id


    respond_to do |format|
      if @upload.save!
        format.html {redirect_to uploads_path, notice: 'Video was successfully uploaded.'}
        format.json {render :show, status: :created, location: @upload}
      else
        format.html {render :edit}
        format.json {render json: @upload.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @upload.destroy
    respond_to do |format|
      format.html {redirect_to uploads_path, notice: 'Video was successfully removed.'}
      format.json {head :no_content}
    end
  end

  def update
    respond_to do |format|
      if @upload.update(upload_params)
        format.html {redirect_to @upload, notice: 'Video was successfully updated.'}
        format.json {render :show, status: :ok, location: @upload}
      else
        format.html {render :edit}
        format.json {render json: @upload.errors, status: :unprocessable_entity}
      end
    end
  end

  private

# Use strong_parameters for attribute whitelisting
# Be sure to update your create() and update() controller methods.

  def upload_params
    params.require(:upload).permit(:video, :name)
  end

end
