class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => :new
  before_filter :admin_user?, :only => [:destroy, :toggle_admin]

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @user_posts = @user.notices.all if @user.notices.count > 0
    @user_posts << @user.comments.all if @user.comments.count > 0 
    @user_posts << @user.karma_grants.all if @user.karma_grants.count > 0
    if @user_posts != nil
      @user_posts.flatten!
      @user_posts.sort! { |b,a| a.created_at <=> b.created_at }
    end
    
  end

  def new
    @user = User.new
    @title = "Sign up"
    render '/devise/registrations/new'
  end
  

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      @title = @user.name + " | Edit profile"
      render '/devise/registrations/edit'
    else
      flash[:error] = "Can't edit other users"
      redirect_to :root
    end
    
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
    @user = User.find(params[:id])
    
    if current_user.admin?
    @user.toggle!(:admin)
    @user.admin? ? flash[:notice] = "User made admin" : flash[:notice] = "User admin revoked"
    else
      flash[:error] = "Not authorized!"
    end
    redirect_to :action => :index
  end
  
private

  def admin_user?
    redirect_to(user_path) unless current_user.admin?
  end

end
