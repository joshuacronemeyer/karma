class NoticesController < ApplicationController

  include ApplicationHelper

  before_filter :authenticate_user!


  def create
   @notice = current_user.notices.new(params[:notice])
      if @notice.save
        if params[:comment] != ""
          @comment = @notice.comments.new
          @comment.original_comment = true
          @comment.user_id = current_user.id
          @comment.comment = params[:comment]
          @comment.save
        end
        flash[:success] = "notice added!"
 
      else
        flash[:error] = "error!"
      end
      redirect_to root_path
    
  end

  def show
    @notice = Notice.find(params[:id])
    @title = first_words(@notice.content, 3)
    if @notice.content.split(/\W+/).count > 3
      @title += "..."
    end  
  end

  def destroy
    @notice = Notice.find(params[:id])
    if @notice.user_id == current_user.id
 #     @notice.karma_grants.each { |kg| kg.destroy }
  #    @notice.comments.each { |c| c.destroy }
      @notice.destroy
      flash[:success] = "Notice deleted."
    else
      flash[:error] = "Not authorized."
    end
    redirect_back_or root_path

    
  end


end
