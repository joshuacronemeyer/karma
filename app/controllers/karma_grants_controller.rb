class KarmaGrantsController < ApplicationController

  include ApplicationHelper
  
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy
  
  def create
    if current_user.karma_grants.new( :karma_points => params[:karma_grant][:karma_points],
                                      :notice_id => params[:karma_grant][:notice_id] ).save
      flash[:success] = "Karma granted!" 
    end    
    redirect_back_or root_path
  end

  def destroy
    @karma_grant.destroy
    redirect_back_or root_path
  end
  
private

  def authorized_user
    @karma_grant = KarmaGrant.find(params[:id])
    redirect_back_or root_path unless current_user == @karma_grant.user 
  end
  
    
end
