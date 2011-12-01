class KarmaGrantsController < ApplicationController

  before_filter :authenticate_user!
  
  def create
    @new_karma_grant = KarmaGrant.new(params[:karma_grant])
    @new_karma_grant.user_id = current_user.id
    if @new_karma_grant.already_granted?
      flash[:error] = "Can't grant karma twice"
    elsif @new_karma_grant.self_grant?
      flash[:error] = "Can't grant karma to yourself"
    else
      @new_karma_grant.save
      flash[:success] = "Karma granted!"  
    end
    redirect_to root_path
    
  end


  
end
