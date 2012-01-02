class PagesController < ApplicationController
 
  def home
    @title = "Home"
#    (@notice = Notice.new) if (@notice == nil)
    
    if user_signed_in?
      @notice = Notice.new
      @notice_items = Notice.paginate(:page => params[:page], :per_page => 10)
    end    
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end
  

end
