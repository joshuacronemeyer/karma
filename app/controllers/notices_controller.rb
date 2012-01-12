class NoticesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :current_user?, :only => :destroy
  before_filter :open?, :only => :claim

  def create
    @notice = current_user.notices.new(params[:notice])
    @notice.time_completed = Time.now if !@notice.open
    if @notice.save && !params[:comment].blank?
      @dc = @notice.comments.create!(:user_id => current_user.id,
                              :content => params[:comment])
      @notice.description_comment_id = @dc.id
      @notice.save
    end
    redirect_to root_path  
  end
  
  def update
    @notice = Notice.find(params[:id])
    @notice.time_completed = Time.now if (@notice.open && !params[:notice][:open])
    @notice.completed_by_id = current_user.id if (!params[:notice][:open] && !params[:notice][:self_doer] == 1)
    @notice.update_attributes(params[:notice])
    redirect_to root_path
  end

  def show
    @notice = Notice.find(params[:id])
  end

  def destroy
    @notice.destroy
    redirect_back_or root_path    
  end
  
  def claim
    render 'notices/claim'
  end
  
  def open_index
  end
  
# def update_claimed_status
#   flash[:notice] = "update"
#   redirect_to root_path
# end

private

  def current_user?
    @notice = Notice.find(params[:id])
    redirect_back_or(root_path) unless current_user == @notice.user
  end

  def open?
    @notice = Notice.find(params[:notice_id])
    redirect_back_or(root_path) unless @notice.open
  end

end
