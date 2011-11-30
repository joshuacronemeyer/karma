class PagesController < ApplicationController
 
  def home
    @title = "Home"
    (@notice = Notice.new) if (@notice == nil)
    
    if user_signed_in?
      @notice = Notice.new
      @notice_items = Notice.all
    end
    
  end

  def about
  end

end
