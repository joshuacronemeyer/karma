require 'spec_helper'

describe "Users" do

  describe "signup" do

    it "should show the sign-up page"
    
    it "should have the right title"
     
    it "should have a name field" 
     
    it "should have an email field"
     
    it "should have a password field"

    it "should have a password confirmation field"
    
    it "should redirect users who are already signed-in"

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

    end
    
    describe "failure" do
      
      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end
      
      it "should have an error flash message"
      
      it "should render the 'edit' page"
      
      it "should have the right title"
            
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