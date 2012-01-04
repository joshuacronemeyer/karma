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
      user = Factory(:user)
      visit sign_in_path
      fill_in :email, :with => user.email
      fill_in :password, :with => user.password
      click_button
      visit edit_user_path(user)
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
        @attr = { :email => "user@example.com", :name => "New Name", :password => "barbaz",
                  :password_confirmation => "barbaz" }
      end
      
      it "should change the user's attributes" 
      
      it "should redirect to the user show page"
      
      it "should have a flash message" 
      
    end

  end
  
  describe "self-delete account" do
    
    it "should ask for confirmation"

    it "should delete the user"
    
    it "should render the sign-up page"

  end
  
  describe "admin-delete account" do
    
    it "should ask for confirmation"
    
    it "should delete the user"
    
    it "should render the user index page"
    
  end
  
  
end