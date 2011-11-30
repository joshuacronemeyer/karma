class CommentsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create
    if params[:comment][:comment] != ""
      @comment = Comment.new(params[:comment])
      @comment.user_id = current_user.id
      @comment.original_comment = false
      @comment.save
    end
    flash[:success] = "comment added!"
    redirect_to root_path
  end
  
  
  def new
  end

  def edit
  end

  def destroy
  end

end
