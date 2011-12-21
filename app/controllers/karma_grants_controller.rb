class KarmaGrantsController < ApplicationController

  include ApplicationHelper
  
  before_filter :authenticate_user!
  
  def create
    @new_karma_grant = KarmaGrant.new(params[:karma_grant])
    @new_karma_grant.user_id = current_user.id
    if @new_karma_grant.already_granted?
      flash[:error] = "Error: can't grant karma twice"
    elsif @new_karma_grant.self_grant?
      flash[:error] = "Error: can't grant karma to yourself"
    elsif @new_karma_grant.karma_points > 3
      flash[:error] = "Error: can't grant more than 3 karma points"
    else
      @new_karma_grant.save
      flash[:success] = "Karma granted!"  
    end
    redirect_back_or root_path
  
  end

  def destroy
    @karma_grant = KarmaGrant.find(params[:id])
    if @karma_grant.user_id == current_user.id
      @karma_grant.destroy
      flash[:success] = "Karma revoked"
    else
       flash[:error] = "Not authorized!"
    end 
    redirect_back_or root_path

  end
  
  
end
