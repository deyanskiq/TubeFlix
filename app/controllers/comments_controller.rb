class CommentsController < ApplicationController
  load_and_authorize_resource

  def create
    upload_id = params[:upload_id].to_i

    @comment = Comment.new(comment_params)
    @comment.upload_id = upload_id
    @comment.user_id = current_user.id

    @comment.save!
    redirect_to upload_path(upload_id)

  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html {redirect_to upload_path(@comment.upload_id), notice: 'Comment was successfully removed.'}
      format.json {head :no_content}
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html {redirect_to upload_path(@comment.upload_id), notice: 'Comment was successfully updated.'}
        format.json {render :show, status: :ok, location: @upload}
      else
        format.html {render :edit}
        format.json {render json: @comment.errors, status: :unprocessable_entity}
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end
end
