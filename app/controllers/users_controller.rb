class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => :new
  before_filter :admin_user?, :only => [:destroy, :toggle_admin]
  before_filter :current_user?, :only => :edit
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @user_posts = (@user == current_user ? @user.private_posts : @user.public_posts)
    @user_posts = @user_posts.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @user = User.new
    @title = "Sign up"
    render '/devise/registrations/new'
  end
  
  def edit
    @title = @user.name + " | Edit profile"
    render '/devise/registrations/edit'
  end

  def destroy
    if User.find(params[:id]) == current_user
      flash[:error] = "Admins cannot delete themselves"
      redirect_to :action => :index

    else
      User.find(params[:id]).destroy
      flash[:success] = "User deleted."
      redirect_to users_path
    end

  end
  
  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end
  
  def toggle_admin
    @user = User.find(params[:user_id])  
    if @user != current_user
      @user.toggle!(:admin)
      flash[:notice] = (@user.admin? ? "User made admin" : "User admin revoked")
    else
      flash[:error] = "Admins can't revoke their own status"
    end
    redirect_to :action => :index
  end
  
private

  def admin_user?
    redirect_to(user_path) unless current_user.admin?
  end
  
  def current_user?
    @user = User.find(params[:id])
    redirect_back_or(root_path) unless current_user == @user
  end

end
