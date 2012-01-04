require 'spec_helper'

describe "Notices" do
  
  before(:each) do
    user = Factory(:user)
    visit sign_in_path
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
  end
  
  describe "creation" do
  
    describe "failure" do
      
      it "should not create a new notice" do
        lambda do
          visit root_path
          fill_in :notice_doers, :with => "kidA kidB"
          fill_in :notice_content, :with => ""
          click_button
        end.should_not change(Notice, :count)
      end
      
    end
    
    describe "success" do
      
      it "should create a new notice" do
        lambda do
          visit root_path
          fill_in :notice_doers, :with => "kidA kidB"
          fill_in :notice_content, :with => "stuff"
          click_button
        end.should change(Notice, :count).by(1)
      end
      
    end
    
  end
  
  describe "destruction" do
    
#   describe "failure" do
#     
#     it "should not destroy the notice"
#     
#     it "should render the last viewed page"
#     
#   end
#   
#   describe "success" do
#     
#     it "should destroy the notice"
#     
#     it "should render the last viewed page"
#     
#   end
    
  end
  
  
end
