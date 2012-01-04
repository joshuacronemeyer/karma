class PagesController < ApplicationController
 
  def home
    if user_signed_in?
      @notice = Notice.new
      @notice_items = Notice.paginate(:page => params[:page], :per_page => 10)
    end    
  end

  def about
  end

  def help
  end
  

end
