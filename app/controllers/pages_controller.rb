class PagesController < ApplicationController
 
  def home
    if user_signed_in?
      @notice = Notice.new
      @closed_notice_items = Notice.closed_notices.paginate(:page => params[:page], :per_page => 10)
      @open_notice_items = Notice.open_notices
    end    
  end

  def about
  end

  def help
  end
  

end
