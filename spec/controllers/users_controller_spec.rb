require 'spec_helper'

describe UsersController do

  render_views

  describe "GET 'index'" do
  
    describe "for non-signed-in users" do

      before(:each) do
        @user = Factory(:user)
      end

      it "should deny access" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
      

    end
    
    describe "for signed-in users" do
      
      before(:each) do
        test_sign_in(@user)
      end
      
      
      it "should be successful" 
      
      it "should have the right title" 
      
      it "should have an element for each user" 
      
      it "should paginate users"
      
      it "should not show delete links to non-admins"
      
      it "should show delete links to admins"
      
    end
    
  end

  describe "GET 'show'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
        get :show, :id => @user
        response.should be_success
    end
    
    it "should find the right user" do
        get :show, :id => @user
        assigns(:user).should == @user
    end
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end
    
    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h3", :content => @user.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("img", :class => "gravatar")
    end

    it "should show the user's notices"
    
    it "should show the user's comments"
    
    describe "for a user's own page" do

      it "should show a user's karma grants"

      it "should show delete links for notices"
      
      it "should show delete links for comments"
      
      it "should show revoke links for karma grants"

    end
    
    describe "for another user's page" do

      it "should not show a user's karma grants"
      
      it "should not show delete links for notices"
      
      it "should not show delete links for comments"
      
      it "should not show revoke links for karma grants"
      
    end
      
  end
   
  describe "GET 'edit'" do 
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit")
    end
    
    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "change")
    end
    
  end
  
  describe "toggle_admin" do
    
    it "should allow admins to make other admins"
    
    it "should allow admins to revoke admin status"
    
    it "should not allow non-admins to make admins"
  
  end
  
  
  describe "authentication of edit page" do
    
    before (:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed-in users" do
      
      it "should deny access" do
        get :edit, :id => @user
        response.should redirect_to(new_user_session_path)
      end
      
    end
    
    describe "for signed-in user" do
      
      before (:each) do
        wrong_user = Factory(:user, :name => "Wrong User", :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should not allow users to edit others' profiles" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
    
      
    end
    
  end
  
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(user_path)
      end
    end
    
    describe "as an admin user" do
      
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
      
      it "should not allow admins to destroy themselves" do
        delete :destroy, :id => @admin
        response.should redirect_to('/users')
      end
      
    end
  
  end
  
end
