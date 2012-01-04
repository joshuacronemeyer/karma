class NoticesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :current_user?, :only => :destroy

  def create
    @notice = current_user.notices.new(params[:notice])
    if @notice.save
      @notice.comments.create(:user_id => current_user.id,
                              :comment => params[:comment])
      flash[:success] = "notice added"
    else
      flash[:error] = "Error"
    end
    redirect_to root_path  
  end

  def show
    @notice = Notice.find(params[:id])
  end

  def destroy
    @notice.destroy
    redirect_back_or root_path    
  end

private

  def current_user?
    @notice = Notice.find(params[:id])
    redirect_back_or(root_path) unless current_user == @notice.user
  end

end
