require 'spec_helper'

describe "Layout links" do
  
  it "should have a home page at '/'" do
    get '/'
    response.should have_selector('title', :content => "Home")
  end
  
  it "should have an about page at '/about'" do
    get '/about'
    response.should have_selector('title', :content => "About")
  end
  
  it "should have a help page at '/help'" do
    get '/help'
    response.should have_selector('title', :content => "Help")
  end
  
  it "should have a Signup page at '/signup'" do
    get '/sign_up'
      response.should have_selector('title', :content => "Sign up")
  end
  
  it "should have the right links on the layout" do
    visit root_path
      click_link "About"
      response.should have_selector('title', :content => "About")
      click_link "Help"
      response.should have_selector('title', :content => "Help")
      click_link "Home"
      response.should have_selector('title', :content => "Home")
      click_link "Sign up"
      response.should have_selector('title', :content => "Sign up")


      describe "when not signed in" do

        it "should have a signin link" do
          visit root_path
          response.should have_selector("a", :href => sign_in_path,
                                             :content => "Sign in")
        end

      end

      describe "when signed in" do

        before(:each) do
          @user = Factory(:user)
          integration_sign_in(@user)
        end

        it "should have a signout link" do
          visit root_path
          response.should have_selector("a", :href => sign_out_path,
                                             :content => "Sign out")
        end

        it "should have a profile link" do
          visit root_path
          response.should have_selector("a", :href => user_path(@user),
                                             :content => "Profile")  
        end


      end
  
  end
  
  
end