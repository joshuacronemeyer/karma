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

#  def create
#    @user = User.new(params[:user])
#    if @user.save
#    #  sign_in @user
#      flash[:success] = "Welcome to Karma!"
#      redirect_to @user
#    else
#      @title = "Sign up"
#      render 'new'
#    end
#  end

  def edit
  end

  def destroy
  end
  
  def index
    @users = User.all
    @title = "All users"
  end
  

end
