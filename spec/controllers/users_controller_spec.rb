require 'spec_helper'

describe UsersController do

  render_views

  describe "GET 'new'" do
    
    it "should be successful" do
      get :new
      response.should be_success
    end

    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign up")
    end
    
    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    
    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    
    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end
      
    it "should have a password confirmation field" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end

    it "should redirect users who are already signed-in" do
      @user = Factory(:user)
      test_sign_in(@user)
      get :new
      response.should redirect_to(root_path)
    end

  end

  describe "GET 'show'" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h3", :content => @user.name)
    end

  end

  describe "GET 'edit'" do
    it "should be successful" do
      get :edit
      response.should be_success
    end
  end

  describe "GET 'destroy'" do
    it "should be successful" do
      get :destroy
      response.should be_success
    end
  end

  describe "POST 'create'" do

     describe "failure" do

       before(:each) do
         @attr = { :name => "", :email => "", :password => "",
                   :password_confirmation => "" }
       end

       it "should not create a user" do
         lambda do
           post :create, :user => @attr
         end.should_not change(User, :count)
       end

       it "should have the right title" do
         post :create, :user => @attr
         response.should have_selector("title", :content => "Sign up")
       end

       it "should render the 'new' page" do
         post :create, :user => @attr
         response.should render_template('new')
       end
     end
     
     describe "success" do

       before(:each) do
         @attr = { :name => "New User", :email => "user@example.com",
                   :password => "foobar", :password_confirmation => "foobar" }
       end

       it "should create a user" do
         lambda do
           post :create, :user => @attr
         end.should change(User, :count).by(1)
       end

       it "should redirect to the user show page" do
         post :create, :user => @attr
         response.should redirect_to(user_path(assigns(:user)))
       end    
       
       it "should have a welcome message" do
         post :create, :user => @attr
         flash[:success].should =~ /welcome to/i
       end
     end
   end
end