class NoticesController < ApplicationController

#  before_filter :authenticate_user!


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
        redirect_to root_path
      else
        flash[:error] = "error!"
       redirect_to root_path       
      end
  end

  def show
  end

  def destroy
  end

end
