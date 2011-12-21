class CommentsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def create    
    if params[:comment][:comment] != ""
      @comment = Comment.new(params[:comment])
      @comment.user_id = current_user.id
      @comment.original_comment = false
      @comment.save
      flash[:success] = "Comment added!"
    else      
      flash[:error] = "Can't post a blank comment!"
    end
    redirect_back_or root_path
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id
      @comment.destroy
      flash[:success] = "Comment deleted"
    else
       flash[:error] = "Not authorized!"
    end 
    redirect_back_or root_path

  end

end
