class NoticesController < ApplicationController

  include ApplicationHelper

  before_filter :authenticate_user!

  def create
    @notice = current_user.notices.new(params[:notice],
                                      :open => false,
                                      :display_title => trunc_title(params[:notice][:content], 3))
    if @notice.save
      @notice.comments.create(:user_id => current_user.id,
                              :comment => params[:comment])
      flash[:success] = "notice added"
    end
  redirect_to root_path  
  end

  def show
    @notice = Notice.find(params[:id])
    @title = @notice.display_title
 #   @title = first_words(@notice.content, 3)
#    if @notice.content.split(/\W+/).count > 3
#      @title += "..."
#    end  
  end

  def destroy
    @notice = Notice.find(params[:id])
    if @notice.user.id == current_user.id
      @notice.destroy
      flash[:success] = "Notice deleted."
    else
      flash[:error] = "Not authorized."
    end
    redirect_back_or root_path

    
  end


end
