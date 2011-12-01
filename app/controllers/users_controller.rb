class UsersController < ApplicationController

  before_filter :authenticate_user!

  def new
    @user = User.new
    @title = "Sign up"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def edit
  end

  def destroy
  end
  
  def index
    @users = User.all
    @title = "All users"
  end
  

end
