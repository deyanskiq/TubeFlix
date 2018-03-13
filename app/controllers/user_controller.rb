class UserController < ApplicationController
  load_and_authorize_resource

  # this is necessery due to devise; without this helper method in any context different from devise resource won't be visible
  helper_method :resource_name, :resource, :devise_mapping, :resource_class

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end


  # GET /user
  # GET /user.json
  def index
    @users = User.all
  end

  # GET /user/1
  # GET /user/1.json
  def show
    @user = User.find(params[:id])
  end

  # GET /user/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /user
  # POST /user.json
  def create
    @user = User.new(user_params)
    @user.owner_id = current_user.id

    if current_user.role == 'Admin'
      @user.role = 'Reseller'
    else
      @user.role = 'User'
    end
    respond_to do |format|
      if @user.save!
        format.html {redirect_to user_index_path, notice: 'User was successfully created.'}
        format.json {render :show, status: :created, location: @user}
      else
        format.html {render :new}
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /user/1/edit
  def update
    respond_to do |format|
      if @user.update(user_params)
        if @user.id == current_user.id
          format.html {redirect_to new_user_session_path, notice: 'Sign up with the new credentials.'}
        else
          format.html {redirect_to user_index_path, notice: 'User was successfully updated.'}
          format.json {render :show, status: :ok, location: @user}
        end
      else
        format.html {render :edit}
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /user/1
  # DELETE /user/1.json
  def destroy
    if @user.role == 'Reseller'
      # why @user.subordinates.each {|user| user.update_attribute(:owner_id, -1)} doesn't work; delete both reseller and user
      User.get_users_by_reseller(@user).each {|user| user.update_attribute(:owner_id, -1)}
    end

    @user.destroy

    respond_to do |format|
      if @user.id == current_user.id
        format.html {redirect_to new_user_session_path, notice: 'Profile was successfully destroyed.'}

      else
        format.html {redirect_to user_index_path, notice: 'User was successfully destroyed.'}
        format.json {head :no_content}
      end
    end
  end

  def compound_destroy
    # user.uploads.each(&:destroy)
    binding.pry
    @user.destroy

    respond_to do |format|
      if @user.id == current_user.id
        format.html {redirect_to new_user_session_path, notice: 'Profile all his Users Profiles were successfully destroyed.'}

      else
        format.html {redirect_to user_index_path, notice: 'Reseller and all his Users were successfully destroyed.'}
        format.json {head :no_content}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role, :owner_id)
  end
end
