require 'spec_helper'

describe "Users" do

  describe "signup" do

    it "should show the sign-up page" do
      visit sign_up_path
      response.should be_success
    end
    
    it "should have the right title" do
      visit sign_up_path
      response.should have_selector("title", :content => "Sign up")
    end
     
    it "should have a name field" do
      visit sign_up_path
      response.should have_selector("input", :name => "user[name]")
    end
     
    it "should have an email field" do
      visit sign_up_path
      response.should have_selector("input", :name => "user[email]")
    end
     
    it "should have a password field" do
      visit sign_up_path
      response.should have_selector("input", :name => "user[password]")
    end

    it "should have a password confirmation field" do
      visit sign_up_path
      response.should have_selector("input", :name => "user[password_confirmation]")
    end
    
#  it "should redirect users who are already signed-in" do
#    visit sign_up_path
#    fill_in "Name",         :with => "Example User"
#    fill_in "Email",        :with => "user@example.com"
#    fill_in "Password",     :with => "foobar"
#    fill_in "Password Confirmation", :with => "foobar"
#    click_button
#    visit sign_up_path
#    response.should redirect_to root_path
#  end

    describe "failure" do

      it "should not make a new user" do
        lambda do
          visit sign_up_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Password Confirmation", :with => ""
          click_button
          response.should render_template('devise/registrations/new')
        end.should_not change(User, :count)
      end
    end

    describe "success" do

      it "should make a new user" do
        lambda do
          visit sign_up_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Password Confirmation", :with => "foobar"
          click_button
          response.should render_template('pages/home')
        end.should change(User, :count).by(1)
      end
    end

  end
  
  describe "update" do
    
    before (:each) do
      @user = Factory(:user)
      integration_sign_in(@user)
      visit edit_user_path(@user)
    end
    
    describe "failure" do
      
      before(:each) do
        fill_in "Name",                       :with => "Example User"
        fill_in "New password",               :with => "yesyesyes"
        fill_in "New password Confirmation",  :with => "nonononono"
      end
      
      it "should have an error flash message" do
        click_button
        response.should have_selector("div", :id => "error_explanation")
      end
      
      it "should render the 'edit' page" do
        click_button
        response.should render_template 'devise/registrations/edit'
      end
      
      it "should have the right title" do
        click_button
        response.should have_selector("title", :content => "Edit profile")
      end
            
    end
    
    describe "success" do
      
      before(:each) do
        fill_in "Name",                       :with => "Example User"
        fill_in "New password",               :with => "yesyesyes"
        fill_in "New password Confirmation",  :with => "yesyesyes"
        fill_in "Re-enter current password",  :with => @user.password
      end
      
      it "should change the user's attributes" do
        click_button
        @user = User.find(@user.id)
        @user.name.should == "Example User"
      end
          
      it "should render to the user show page" do
        click_button
        response.should render_template 'users/show'
      end
            
    end

  end
  
  describe "self-delete account" do
    
#   before(:each) do
#     @user = Factory(:user)
#     integration_sign_in(@user)
#   end
#   
#    it "should ask for confirmation" do    
#
#   it "should delete the user" do
#     visit edit_user_path(@user)
#     puts response.inspect
#     lambda do
#       click_link "Cancel my account"
#     end.should change(User, :count).by(-1)
#   end
#   
#   it "should render the sign-up page" do
#     visit edit_user_path(@user)
#     click_link "Cancel my account"
#     response.should render_template 'pages/home'
#   end

  end
  
  describe "admin-delete account" do
    
#   before(:each) do
#     @user = Factory(:user)
#     @user.admin = true
#     integration_sign_in(@user)
#     @second = Factory(:user, :name => "second", :email => "second@example.com")
#   end
#   
#    it "should ask for confirmation" do
#   
#   it "should delete the user" do
#     visit users_path
#     lambda do
#       click_link "Delete second"
#     end.should change(User, :count).by(-1)
#   end
#   
#   it "should render the user index page" do
#     visit users_path
#     click_link "Delete second"
#     response.should render_template 'users/index'
#   end
#   
  end
  
  
end