class CommentsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :current_user?, :only => :destroy
  
  def create    
    @comment = current_user.comments.build(params[:comment], :original_comment => false)
    @comment.save ? flash[:success] = "Comment added!" : flash[:error] = "Error"
    redirect_back_or root_path
  end
  
  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_back_or root_path
  end

private
  
  def current_user?
    @comment = Comment.find(params[:id])
    redirect_back_or(root_path) unless current_user == @comment.user
  end
  
end
